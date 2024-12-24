
import javax.swing.JOptionPane;
import javax.swing.*;
import java.awt.*;
import java.sql.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayInputStream;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.print.PrinterException;
import java.util.ArrayList;
import java.util.List;
import javax.swing.table.DefaultTableModel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
/**
 *
 * @author Asnari Pacalna
 */
public class UserProduct extends javax.swing.JFrame {

    private javax.swing.JComboBox<String> categoryComboBox;
    private String loggedInUsername;
    private Connection connection;

    /**
     * Creates new form UserProduct
     */
    public UserProduct(String username) {
        this.loggedInUsername = username;
        initComponents();
        initializeDatabaseConnection();
        checkUserInformation();
        jComboBox1.addActionListener(e -> filterProducts());
        jTextField1.getDocument().addDocumentListener(new DocumentListener() {
            public void changedUpdate(DocumentEvent e) {
                filterProducts();
            }

            public void removeUpdate(DocumentEvent e) {
                filterProducts();
            }

            public void insertUpdate(DocumentEvent e) {
                filterProducts();
            }
        });
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });
        loadProducts("", "All");
    }

    private void initializeDatabaseConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/wms", "root", "");
        } catch (Exception e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this,
                    "Error connecting to database: " + e.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }
    }

    private String generateOrderId() {
       String newOrderId = "ORD-001"; // Default if no orders exist
    
    try {
        String query = "SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1";
        PreparedStatement pst = connection.prepareStatement(query);
        ResultSet rs = pst.executeQuery();
        
        if (rs.next()) {
            String currentId = rs.getString("order_id");
            String numberPart = currentId.substring(4); // Gets "018"
            int nextNumber = Integer.parseInt(numberPart) + 1;
            newOrderId = String.format("ORD-%03d", nextNumber);
        }
        
        rs.close();
        pst.close();
        
    } catch (SQLException e) {
        e.printStackTrace(System.err);
        JOptionPane.showMessageDialog(this,
                "Error generating order ID: " + e.getMessage(),
                "Database Error",
                JOptionPane.ERROR_MESSAGE);
    }
    
    return newOrderId;
    }

    private void saveOrder(DefaultTableModel model, double total, double cash) {
    try {
        connection.setAutoCommit(false);
        String orderId = generateOrderId();
        int customerId = getCustomerId();

        // Insert into orders table
        String query = "INSERT INTO orders (order_id, customer_id, status, order_date) VALUES (?, ?, 'PENDING', NOW())";
        PreparedStatement pst = connection.prepareStatement(query);
        pst.setString(1, orderId);
        pst.setInt(2, customerId);
        pst.executeUpdate();
        pst.close();

        // Save order items and update product stock
        String itemsQuery = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateStockQuery = "UPDATE products SET stock = stock - ? WHERE product_id = ?";

        PreparedStatement itemsPst = connection.prepareStatement(itemsQuery);
        PreparedStatement updateStockPst = connection.prepareStatement(updateStockQuery);

        for (int i = 0; i < model.getRowCount(); i++) {
            int productId = (Integer) model.getValueAt(i, 0);
            int quantity = (Integer) model.getValueAt(i, 2);

            // Insert order items
            itemsPst.setString(1, orderId);
            itemsPst.setInt(2, productId);
            itemsPst.setInt(3, quantity);
            itemsPst.addBatch();

            // Update product stock
            updateStockPst.setInt(1, quantity);
            updateStockPst.setInt(2, productId);
            updateStockPst.addBatch();
        }

        itemsPst.executeBatch();
        updateStockPst.executeBatch();

        connection.commit();  // Commit transaction

        // Generate and display receipt
        StringBuilder receipt = new StringBuilder();
        receipt.append("===========================================\n");
        receipt.append("               SALES RECEIPT               \n");
        receipt.append("===========================================\n");
        receipt.append(String.format("Order ID: %s\n", orderId));
        receipt.append(String.format("Date: %s\n",
                java.time.LocalDateTime.now().format(
                        java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))));
        receipt.append("-----------------------------------------------------------------------------\n");
                     
        receipt.append(String.format("%-3s %-25s %5s %12s\n",
                "No.", "Product", "Qty", "Price"));
        receipt.append("-----------------------------------------------------------------------------\n");

        for (int i = 0; i < model.getRowCount(); i++) {
            String product = model.getValueAt(i, 1).toString();
            int quantity = (Integer) model.getValueAt(i, 2);
            double price = (Double) model.getValueAt(i, 3);

            if (product.length() > 22) {
                product = product.substring(0, 22) + "...";
            }

            receipt.append(String.format("%-3d %-25s %5d %,12.2f\n",
                    (i + 1), product, quantity, price));
        }

        receipt.append("-----------------------------------------------------------------------------\n");
        // New aligned format for totals section
        receipt.append(String.format("%-25s ₱%,20.2f \n", "Total Amount:", total));
        receipt.append(String.format("%-25s      ₱%,20.2f \n", "Cash:", cash));
        receipt.append(String.format("%-25s    ₱%,20.2f \n", "Change:", cash - total));
        receipt.append("===========================================\n");
        receipt.append("          Thank you for shopping!          \n");
        receipt.append("===========================================\n");

        // Set the receipt text in the text area
        jTextArea1.setText(receipt.toString());

        // Show success message and prompt for printing
        int choice = JOptionPane.showConfirmDialog(this,
                "Order Successfully Processed!\nOrder ID: " + orderId + "\n\nWould you like to print the receipt?",
                "Success",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.INFORMATION_MESSAGE);

        if (choice == JOptionPane.YES_OPTION) {
            try {
                jTextArea1.print();
            } catch (PrinterException pe) {
                JOptionPane.showMessageDialog(this,
                        "Error printing: " + pe.getMessage(),
                        "Print Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }

        // Ask if user wants to start a new transaction
        int newTransaction = JOptionPane.showConfirmDialog(this,
                "Would you like to start a new transaction?",
                "New Transaction",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.QUESTION_MESSAGE);

        if (newTransaction == JOptionPane.YES_OPTION) {
            // Clear the cart and refresh product display
            jButton11ActionPerformed(null);
        }

    } catch (SQLException e) {
        try {
            connection.rollback();  // Rollback transaction on error
        } catch (SQLException ex) {
            ex.printStackTrace(System.err);
        }
        e.printStackTrace(System.err);
        JOptionPane.showMessageDialog(this,
                "Error saving order: " + e.getMessage(),
                "Database Error",
                JOptionPane.ERROR_MESSAGE);
    } finally {
        try {
            connection.setAutoCommit(true);  // Reset auto-commit
        } catch (SQLException e) {
            e.printStackTrace(System.err);
        }
    }
}
    
    private int getCustomerId() {
        int customerId = -1;
        try {
            String query = "SELECT customer_id FROM customers WHERE user_id = ?";
            PreparedStatement pst = connection.prepareStatement(query);
            pst.setInt(1, getCurrentUserId());

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }

            rs.close();
            pst.close();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this,
                    "Error retrieving customer ID: " + e.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }
        return customerId;
    }

    private void saveOrderDetails(String orderId, DefaultTableModel model) {
        try {
            String query = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = connection.prepareStatement(query);

            for (int i = 0; i < model.getRowCount(); i++) {
                pst.setString(1, orderId);
                pst.setInt(2, (Integer) model.getValueAt(i, 0)); // product_id
                pst.setInt(3, (Integer) model.getValueAt(i, 2)); // quantity
                pst.setDouble(4, (Double) model.getValueAt(i, 3)); // price
                pst.addBatch();
            }

            pst.executeBatch();
            pst.close();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this,
                    "Error saving order details: " + e.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }
    }

    private int getCurrentUserId() {
        int userId = -1;
        try {
            String query = "SELECT user_id FROM accountdetails WHERE accUsername = ?";
            PreparedStatement pst = connection.prepareStatement(query);
            pst.setString(1, loggedInUsername);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("user_id");
            }

            rs.close();
            pst.close();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this,
                    "Error retrieving user ID: " + e.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }
        return userId;
    }

    private void checkUserInformation() {
        int currentUserId = getCurrentUserId();
        try {
            String checkSQL = "SELECT c.email, c.phone, c.address FROM customers c "
                    + "WHERE c.user_id = ?";

            PreparedStatement pst = connection.prepareStatement(checkSQL);
            pst.setInt(1, currentUserId);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String address = rs.getString("address");

                if (email == null || email.trim().isEmpty()
                        || phone == null || phone.trim().isEmpty()
                        || address == null || address.trim().isEmpty()
                        || address.equals("Address not set")) {

                    UpdateInfoDialog dialog = new UpdateInfoDialog(this, currentUserId);
                    dialog.setVisible(true);

                    if (!dialog.isUpdated()) {
                        dispose();
                        new UserHome(loggedInUsername).setVisible(true);
                    }
                }
            }

            rs.close();
            pst.close();

        } catch (SQLException e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this,
                    "Error checking user information: " + e.getMessage(),
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
        }
    }

    private void filterProducts() {
        String searchText = jTextField1.getText().trim();
        String category = (String) jComboBox1.getSelectedItem();
        System.out.println("Filtering - Search: " + searchText + ", Category: " + category);
        loadProducts(searchText, category);
    }
// Add this method to load products

    private void loadProducts(String searchText, String category) {
        try {
            StringBuilder queryBuilder = new StringBuilder(
                    "SELECT product_id, product_name, price, stock, category, image_data "
                    + "FROM products WHERE active = 1");
            List<String> conditions = new ArrayList<>();
            List<Object> parameters = new ArrayList<>();

            if (!searchText.isEmpty()) {
                conditions.add("product_name LIKE ?");
                parameters.add("%" + searchText + "%");
            }
            if (!category.equals("All")) {
                conditions.add("category = ?");
                parameters.add(category);
            }
            if (!conditions.isEmpty()) {
                queryBuilder.append(" AND ").append(String.join(" AND ", conditions));
            }

            PreparedStatement pst = connection.prepareStatement(queryBuilder.toString());
            for (int i = 0; i < parameters.size(); i++) {
                pst.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = pst.executeQuery();
            jPanel5.removeAll();
            jPanel5.setLayout(new GridLayout(0, 3, 10, 10));

            while (rs.next()) {
                JPanel productPanel = createProductPanel(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getBytes("image_data")
                );
                jPanel5.add(productPanel);
            }

            jPanel5.revalidate();
            jPanel5.repaint();
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace(System.err);
            JOptionPane.showMessageDialog(this, "Error loading products: " + e.getMessage());
        }
    }

    @Override
    public void dispose() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        super.dispose();
    }
// Helper method to create product panels

 private JPanel createProductPanel(int id, String name, double price, int stock, byte[] imageData) {
    JPanel panel = new JPanel();
    panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
    panel.setBorder(BorderFactory.createLineBorder(Color.BLACK));
    panel.setPreferredSize(new Dimension(180, 300));

    // Create the image panel
    JPanel imageContainer = new JPanel(new BorderLayout());
    imageContainer.setPreferredSize(new Dimension(200, 170));
    
    if (imageData != null && imageData.length > 0) {
        try {
            BufferedImage originalImage = ImageIO.read(new ByteArrayInputStream(imageData));
            Image scaledImage = originalImage.getScaledInstance(200, 170, Image.SCALE_SMOOTH);
            JLabel imageLabel = new JLabel(new ImageIcon(scaledImage));
            imageLabel.setHorizontalAlignment(JLabel.CENTER);
            imageContainer.add(imageLabel, BorderLayout.CENTER);
        } catch (Exception e) {
            e.printStackTrace();
            JLabel errorLabel = new JLabel("Error loading image");
            errorLabel.setHorizontalAlignment(JLabel.CENTER);
            imageContainer.add(errorLabel, BorderLayout.CENTER);
        }
    } else {
        JLabel noImageLabel = new JLabel("No Image");
        noImageLabel.setHorizontalAlignment(JLabel.CENTER);
        imageContainer.add(noImageLabel, BorderLayout.CENTER);
    }

    // If stock is 0, overlay "Out of Stock" message
    if (stock == 0) {
        JPanel overlayPanel = new JPanel();
        overlayPanel.setBackground(new Color(255, 255, 255, 200)); // Semi-transparent white
        JLabel outOfStockLabel = new JLabel("OUT OF STOCK");
        outOfStockLabel.setFont(new Font("Segoe UI", Font.BOLD, 16));
        outOfStockLabel.setForeground(new Color(179, 1, 104)); // Match the app's color scheme
        overlayPanel.add(outOfStockLabel);
        imageContainer.add(overlayPanel, BorderLayout.CENTER);
    }

    panel.add(imageContainer);

    JLabel nameLabel = new JLabel(name);
    nameLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
    nameLabel.setFont(new Font("Segoe UI", Font.BOLD, 14));

    JLabel priceLabel = new JLabel(String.format("Price: ₱%.2f", price));
    priceLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

    JSpinner quantitySpinner = new JSpinner(new SpinnerNumberModel(0, 0, stock, 1));
    JCheckBox purchaseBox = new JCheckBox("Purchase");

    // Disable controls if out of stock
    if (stock == 0) {
        quantitySpinner.setEnabled(false);
        purchaseBox.setEnabled(false);
    }

    quantitySpinner.addChangeListener(e -> updatePurchaseStatus(id, name, price, (int) quantitySpinner.getValue(), purchaseBox.isSelected()));
    purchaseBox.addActionListener(e -> updatePurchaseStatus(id, name, price, (int) quantitySpinner.getValue(), purchaseBox.isSelected()));

    panel.add(Box.createVerticalStrut(10));
    panel.add(nameLabel);
    panel.add(Box.createVerticalStrut(5));
    panel.add(priceLabel);
    panel.add(Box.createVerticalStrut(5));

    JPanel quantityPanel = new JPanel();
    quantityPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
    quantityPanel.add(new JLabel("Quantity:"));
    quantityPanel.add(quantitySpinner);
    panel.add(quantityPanel);

    panel.add(Box.createVerticalStrut(5));
    panel.add(purchaseBox);
    panel.add(Box.createVerticalStrut(10));

    return panel;
}
    private boolean validateStock(DefaultTableModel model) {
        try {
            String query = "SELECT stock FROM products WHERE product_id = ?";
            PreparedStatement pst = connection.prepareStatement(query);

            for (int i = 0; i < model.getRowCount(); i++) {
                int productId = (Integer) model.getValueAt(i, 0);
                int requestedQuantity = (Integer) model.getValueAt(i, 2);

                pst.setInt(1, productId);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    int currentStock = rs.getInt("stock");
                    if (currentStock < requestedQuantity) {
                        return false;
                    }
                }
                rs.close();
            }
            pst.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            return false;
        }
    }

    private void generateReceipt(DefaultTableModel model, double total, double cash, double balance) {
        StringBuilder receipt = new StringBuilder();
        receipt.append("===========================================\n");
        receipt.append("               SALES RECEIPT               \n");
        receipt.append("===========================================\n");
        receipt.append(String.format("Date: %s\n",
                java.time.LocalDateTime.now().format(
                        java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))));
        receipt.append("-------------------------------------------\n");
        receipt.append(String.format("%-3s %-25s %5s %12s\n",
                "No.", "Product", "Qty", "Price"));
        receipt.append("-------------------------------------------\n");

        for (int i = 0; i < model.getRowCount(); i++) {
            String product = model.getValueAt(i, 1).toString();
            int quantity = (int) model.getValueAt(i, 2);
            double price = (double) model.getValueAt(i, 3);

            if (product.length() > 22) {
                product = product.substring(0, 22) + "...";
            } else {
                product = String.format("%-25s", product);
            }

            receipt.append(String.format("%-3d %-25s %5d %,12.2f\n",
                    (i + 1), product, quantity, price));
        }

        receipt.append("-------------------------------------------\n");
        receipt.append(String.format("%1s %,12.2f\n", "Total Amount: ₱", total));
        receipt.append(String.format("%1s %,12.2f\n", "Cash: ₱", cash));
        receipt.append(String.format("%1s %,12.2f\n", "Change: ₱", balance));
        receipt.append("===========================================\n");
        receipt.append("          Thank you for shopping!          \n");
        receipt.append("===========================================\n");

        jTextArea1.setText(receipt.toString());
    }

    private void initializeCashField() {
        // Remove default text
        jTextField2.setText("");

        // Add document listener to validate input
        jTextField2.getDocument().addDocumentListener(new DocumentListener() {
            public void changedUpdate(DocumentEvent e) {
                validateCash();
            }

            public void removeUpdate(DocumentEvent e) {
                validateCash();
            }

            public void insertUpdate(DocumentEvent e) {
                validateCash();
            }
        });
    }

    private void validateCash() {
        try {
            String text = jTextField2.getText().trim();
            if (!text.isEmpty()) {
                double cash = Double.parseDouble(text);
                if (cash < 0) {
                    jTextField2.setText("");
                }
            }
        } catch (NumberFormatException e) {
            jTextField2.setText("");
        }
    }

    private void updatePurchaseStatus(int id, String name, double price, int quantity, boolean isPurchased) {
        DefaultTableModel model = (DefaultTableModel) jTable1.getModel();

        // Check if the product is already in the table
        for (int i = 0; i < model.getRowCount(); i++) {
            if ((int) model.getValueAt(i, 0) == id) {
                if (isPurchased && quantity > 0) {
                    // Update existing row
                    model.setValueAt(quantity, i, 2);
                    model.setValueAt(price * quantity, i, 3);
                } else {
                    // Remove row if unchecked or quantity is 0
                    model.removeRow(i);
                }
                updateTotal();
                return;
            }
        }

        // Add new row if not found and is purchased
        if (isPurchased && quantity > 0) {
            model.addRow(new Object[]{id, name, quantity, price * quantity});
        }
        updateTotal();
    }

    private void updateTotal() {
        DefaultTableModel model = (DefaultTableModel) jTable1.getModel();
        double total = 0;
        for (int i = 0; i < model.getRowCount(); i++) {
            total += (double) model.getValueAt(i, 3);
        }
        jLabel9.setText(String.format("%.2f", total));
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jButton2 = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jButton8 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jPanel4 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        jLabel24 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        jTextField1 = new javax.swing.JTextField();
        jButton7 = new javax.swing.JButton();
        jButton9 = new javax.swing.JButton();
        jButton11 = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jPanel5 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jSpinner1 = new javax.swing.JSpinner();
        jCheckBox1 = new javax.swing.JCheckBox();
        jLabel15 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox<>();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(179, 1, 104));
        jPanel1.setPreferredSize(new java.awt.Dimension(240, 682));

        jButton2.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jButton2.setIcon(new javax.swing.ImageIcon("C:\\Users\\Asnari Pacalna\\Documents\\NetBeansProjects\\WarehouseSystem\\src\\Icons\\home-black.png")); // NOI18N
        jButton2.setText("Home");
        jButton2.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jLabel2.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Warehouse  ");

        jButton8.setBackground(new java.awt.Color(0, 0, 0));
        jButton8.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jButton8.setForeground(new java.awt.Color(255, 255, 255));
        jButton8.setIcon(new javax.swing.ImageIcon("C:\\Users\\Asnari Pacalna\\Documents\\NetBeansProjects\\WarehouseSystem\\src\\Icons\\product-white.png")); // NOI18N
        jButton8.setText("Products");
        jButton8.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        jButton5.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jButton5.setIcon(new javax.swing.ImageIcon("C:\\Users\\Asnari Pacalna\\Documents\\NetBeansProjects\\WarehouseSystem\\src\\Icons\\packing-black.png")); // NOI18N
        jButton5.setText("Settings");
        jButton5.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton6.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jButton6.setIcon(new javax.swing.ImageIcon("C:\\Users\\Asnari Pacalna\\Documents\\NetBeansProjects\\WarehouseSystem\\src\\Icons\\logout.png")); // NOI18N
        jButton6.setText("LOGOUT");
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(14, 14, 14)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(47, 47, 47)
                        .addComponent(jLabel2))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jButton6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(14, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(32, 32, 32)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(51, 51, 51)
                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(26, 26, 26))
        );

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setPreferredSize(new java.awt.Dimension(805, 682));

        jLabel1.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel1.setText("Products Overview");

        jPanel4.setBackground(new java.awt.Color(179, 1, 104));
        jPanel4.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153), 2));

        jPanel8.setBackground(new java.awt.Color(255, 255, 255));

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID", "Product", "Qty", "Price"
            }
        ));
        jTable1.setRowHeight(40);
        jScrollPane2.setViewportView(jTable1);

        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jScrollPane3.setViewportView(jTextArea1);

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jScrollPane3)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 257, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 222, Short.MAX_VALUE)
                .addContainerGap())
        );

        jLabel24.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel24.setForeground(new java.awt.Color(255, 255, 255));
        jLabel24.setText("Cash :");

        jLabel26.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel26.setForeground(new java.awt.Color(255, 255, 255));
        jLabel26.setText("Total :");

        jLabel25.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel25.setForeground(new java.awt.Color(255, 255, 255));
        jLabel25.setText("Balance :");

        jTextField2.setFont(new java.awt.Font("Segoe UI", 1, 12)); // NOI18N

        jLabel3.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(255, 255, 255));

        jLabel9.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel9.setForeground(new java.awt.Color(255, 255, 255));

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jPanel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addGap(25, 25, 25)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel26)
                            .addComponent(jLabel24)
                            .addComponent(jLabel25))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(0, 0, Short.MAX_VALUE)))))
                .addContainerGap())
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 8, Short.MAX_VALUE)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel26)
                    .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(10, 10, 10)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel24)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(10, 10, 10)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(9, 9, 9))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel25)
                        .addContainerGap(13, Short.MAX_VALUE))))
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153), 2));

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 387, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 32, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jButton7.setBackground(new java.awt.Color(179, 1, 104));
        jButton7.setFont(new java.awt.Font("Segoe UI", 1, 12)); // NOI18N
        jButton7.setForeground(new java.awt.Color(255, 255, 255));
        jButton7.setText("PAY");
        jButton7.setBorder(null);
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jButton9.setBackground(new java.awt.Color(179, 1, 104));
        jButton9.setFont(new java.awt.Font("Segoe UI", 1, 12)); // NOI18N
        jButton9.setForeground(new java.awt.Color(255, 255, 255));
        jButton9.setText("PRINT");
        jButton9.setBorder(null);
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        jButton11.setBackground(new java.awt.Color(179, 1, 104));
        jButton11.setFont(new java.awt.Font("Segoe UI", 1, 12)); // NOI18N
        jButton11.setForeground(new java.awt.Color(255, 255, 255));
        jButton11.setText("RESET");
        jButton11.setBorder(null);
        jButton11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton11ActionPerformed(evt);
            }
        });

        jPanel5.setBackground(new java.awt.Color(255, 255, 255));

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));

        jLabel4.setText("Price:");

        jLabel5.setText("Quantity:");

        jLabel6.setText("Purchase:");

        jLabel7.setText("jLabel7");

        jLabel8.setText("jLabel8");

        jLabel15.setBackground(new java.awt.Color(204, 204, 204));
        jLabel15.setOpaque(true);

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5)
                            .addComponent(jLabel6))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 23, Short.MAX_VALUE)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jSpinner1, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGap(6, 6, 6)
                                .addComponent(jCheckBox1)))
                        .addContainerGap())
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(33, 33, 33))))
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(47, 47, 47)
                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addComponent(jLabel15, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(jLabel8))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jSpinner1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel6)
                    .addComponent(jCheckBox1))
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(436, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(463, Short.MAX_VALUE))
        );

        jScrollPane1.setViewportView(jPanel5);

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "All", "Electronics", "Accessories", "Components", "Peripherals", "Storage", "Networking" }));

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 261, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 107, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 107, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton11, javax.swing.GroupLayout.PREFERRED_SIZE, 107, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 586, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jComboBox1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jComboBox1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 522, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(7, 7, 7)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButton7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addGap(17, 17, 17))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 228, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, 864, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 705, Short.MAX_VALUE)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, 705, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // Home button (Dashboard refresh)
        UserHome userhome = new UserHome(loggedInUsername);
        userhome.setVisible(true);
        userhome.setLocationRelativeTo(null);
        this.dispose();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        UserProduct userproduct = new UserProduct(loggedInUsername);
        userproduct.setVisible(true);
        userproduct.setLocationRelativeTo(null);
        this.dispose();
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        // Packing button
        UserSettings usersettings = new UserSettings(loggedInUsername);
        usersettings.setVisible(true);
        usersettings.setLocationRelativeTo(null);
        this.dispose();
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        int choice = JOptionPane.showConfirmDialog(this,
                "Are you sure you want to logout?",
                "Logout Confirmation",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.QUESTION_MESSAGE);

        if (choice == JOptionPane.YES_OPTION) {
            // Return to login screen
            Login login = new Login();
            login.setVisible(true);
            login.setLocationRelativeTo(null);
            this.dispose(); // Close the dashboard
        }        // TODO add your handling code here:
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        DefaultTableModel model = (DefaultTableModel) jTable1.getModel();

        if (model.getRowCount() == 0) {
            JOptionPane.showMessageDialog(this,
                    "No items in cart!",
                    "Error",
                    JOptionPane.WARNING_MESSAGE);
            return;
        }

        // Validate stock availability before processing
        if (!validateStock(model)) {
            JOptionPane.showMessageDialog(this,
                    "Some products are out of stock!",
                    "Error",
                    JOptionPane.WARNING_MESSAGE);
            return;
        }

        double total = calculateTotal(model);
        double cash = getCashAmount();

        if (cash < 0) {
            return;
        }

        if (cash < total) {
            JOptionPane.showMessageDialog(this,
                    "Insufficient cash amount!",
                    "Error",
                    JOptionPane.WARNING_MESSAGE);
            return;
        }

        double balance = cash - total;
        jLabel3.setText(String.format("%.2f", balance));

        // Process the order
        saveOrder(model, total, cash);
    }

    private double calculateTotal(DefaultTableModel model) {
        double total = 0;
        for (int i = 0; i < model.getRowCount(); i++) {
            total += (double) model.getValueAt(i, 3);
        }
        return total;
    }

    private double getCashAmount() {
        String cashText = jTextField2.getText().trim();
        if (cashText.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Please enter cash amount!",
                    "Error",
                    JOptionPane.WARNING_MESSAGE);
            return -1;
        }

        try {
            return Double.parseDouble(cashText);
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this,
                    "Invalid cash amount!",
                    "Error",
                    JOptionPane.WARNING_MESSAGE);
            return -1;
        }
    }

    private void ignorethis(double total, double cash, double balance) {

    }//GEN-LAST:event_jButton7ActionPerformed

    private void jButton11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton11ActionPerformed
        // Clear the table
        DefaultTableModel model = (DefaultTableModel) jTable1.getModel();
        model.setRowCount(0);

        // Reset the total amount
        jLabel9.setText("0.00");

        // Clear the cash input field
        jTextField2.setText("");

        // Clear the balance field
        jLabel3.setText("");

        // Clear the receipt area
        jTextArea1.setText("");

        // Uncheck all purchase checkboxes and reset spinners
        for (Component c : jPanel5.getComponents()) {
            if (c instanceof JPanel) {
                JPanel productPanel = (JPanel) c;
                for (Component innerC : productPanel.getComponents()) {
                    if (innerC instanceof JCheckBox) {
                        ((JCheckBox) innerC).setSelected(false);
                    } else if (innerC instanceof JSpinner) {
                        ((JSpinner) innerC).setValue(0);
                    }
                }
            }
        }

        // Refresh the product display
        filterProducts();
    }//GEN-LAST:event_jButton11ActionPerformed

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed
        try {
            boolean complete = jTextArea1.print();
            if (complete) {
                JOptionPane.showMessageDialog(this, "Receipt printed successfully!", "Print", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Printing cancelled", "Print", JOptionPane.INFORMATION_MESSAGE);
            }
        } catch (PrinterException pe) {
            JOptionPane.showMessageDialog(this, "Error printing: " + pe.getMessage(), "Print Error", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_jButton9ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(UserProduct.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(UserProduct.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(UserProduct.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(UserProduct.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(UserProduct.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }

        java.awt.EventQueue.invokeLater(() -> {
            Login login = new Login();
            login.setVisible(true);
            login.setLocationRelativeTo(null);
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JComboBox<String> jComboBox1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JSpinner jSpinner1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextArea jTextArea1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    // End of variables declaration//GEN-END:variables
}
