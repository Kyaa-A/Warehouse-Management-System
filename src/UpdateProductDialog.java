
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.awt.Image;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.DecimalFormat;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileNameExtensionFilter;


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JDialog.java to edit this template
 */
/**
 *
 * @author Asnari Pacalna
 */
public class UpdateProductDialog extends javax.swing.JDialog {

    private Connection con;
    private Products parentFrame;
    private String originalProductName;
    private byte[] imageData;

    /**
     * Creates new form UpdateProductDialog
     */
    public UpdateProductDialog(java.awt.Frame parent, boolean modal, String name, double price, int stock, double weight, byte[] currentImageData, Connection con) {
        super(parent, modal);
        initComponents();
        this.parentFrame = (Products) parent;
        this.con = con;
        this.originalProductName = name;
        this.imageData = currentImageData;

        // Format values before setting
        DecimalFormat priceFormat = new DecimalFormat("₱#,##0.00");
        DecimalFormat weightFormat = new DecimalFormat("#,##0.00 kg");

        // Set values to fields
        jTextField1.setText(name);
        jTextField2.setText(priceFormat.format(price));  // Format with peso sign
        jTextField3.setText(String.valueOf(stock));
        jTextField4.setText(weightFormat.format(weight)); // Format with kg

        // Display image if available
        // Display image if available
        if (currentImageData != null && currentImageData.length > 0) {
            try {
                BufferedImage originalImage = ImageIO.read(new ByteArrayInputStream(currentImageData));
                if (originalImage != null) {
                    // Calculate scaling while maintaining aspect ratio
                    int originalWidth = originalImage.getWidth();
                    int originalHeight = originalImage.getHeight();
                    int targetWidth = 115;
                    int targetHeight = 115;

                    double scale = Math.min((double) targetWidth / originalWidth,
                            (double) targetHeight / originalHeight);

                    int scaledWidth = (int) (originalWidth * scale);
                    int scaledHeight = (int) (originalHeight * scale);

                    // Create high-quality scaled image
                    BufferedImage scaledImage = new BufferedImage(scaledWidth, scaledHeight,
                            BufferedImage.TYPE_INT_RGB); // Changed to RGB
                    Graphics2D g2d = scaledImage.createGraphics();

                    // Add background
                    g2d.setBackground(jLabel8.getBackground());
                    g2d.clearRect(0, 0, scaledWidth, scaledHeight);

                    // Set rendering hints for better quality
                    g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION,
                            RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
                    g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                            RenderingHints.VALUE_INTERPOLATION_BICUBIC);
                    g2d.setRenderingHint(RenderingHints.KEY_RENDERING,
                            RenderingHints.VALUE_RENDER_QUALITY);
                    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);
                    g2d.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING,
                            RenderingHints.VALUE_COLOR_RENDER_QUALITY);

                    // Draw using better quality
                    g2d.drawImage(originalImage, 0, 0, scaledWidth, scaledHeight, null);
                    g2d.dispose();

                    jLabel8.setIcon(new ImageIcon(scaledImage));
                }
            } catch (Exception e) {
                System.err.println("Error loading image: " + e.getMessage());
                jLabel8.setIcon(null);
            }
        }

        // Add action listeners
        jButton9.addActionListener(evt -> chooseImage());  // Choose Image button
        jButton1.addActionListener(evt -> updateProduct());  // Update Product button
        jButton2.addActionListener(evt -> dispose());  // Cancel button

        // Set dialog properties
        setTitle("Update Product");
        setResizable(false);
        setLocationRelativeTo(parent);
    }

    private void chooseImage() {
        JFileChooser chooser = new JFileChooser();
        FileNameExtensionFilter filter = new FileNameExtensionFilter(
                "Image files", "jpg", "jpeg", "png", "gif");
        chooser.setFileFilter(filter);

        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            try {
                File file = chooser.getSelectedFile();
                imageData = Files.readAllBytes(file.toPath());

                // Read and display the image with high quality
                BufferedImage originalImage = ImageIO.read(file);
                if (originalImage != null) {
                    // Calculate scaling while maintaining aspect ratio
                    int originalWidth = originalImage.getWidth();
                    int originalHeight = originalImage.getHeight();
                    int targetWidth = 115;
                    int targetHeight = 115;

                    double scale = Math.min((double) targetWidth / originalWidth,
                            (double) targetHeight / originalHeight);

                    int scaledWidth = (int) (originalWidth * scale);
                    int scaledHeight = (int) (originalHeight * scale);

                    // Create high-quality scaled image
                    BufferedImage scaledImage = new BufferedImage(scaledWidth, scaledHeight,
                            BufferedImage.TYPE_INT_RGB); // Changed to RGB
                    Graphics2D g2d = scaledImage.createGraphics();

                    // Add background
                    g2d.setBackground(jLabel8.getBackground());
                    g2d.clearRect(0, 0, scaledWidth, scaledHeight);

                    // Set rendering hints for better quality
                    g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION,
                            RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
                    g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                            RenderingHints.VALUE_INTERPOLATION_BICUBIC);
                    g2d.setRenderingHint(RenderingHints.KEY_RENDERING,
                            RenderingHints.VALUE_RENDER_QUALITY);
                    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);
                    g2d.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING,
                            RenderingHints.VALUE_COLOR_RENDER_QUALITY);

                    // Draw using better quality
                    g2d.drawImage(originalImage, 0, 0, scaledWidth, scaledHeight, null);
                    g2d.dispose();

                    jLabel8.setIcon(new ImageIcon(scaledImage));
                }
            } catch (Exception e) {
                JOptionPane.showMessageDialog(this,
                        "Error loading image: " + e.getMessage(),
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void updateProduct() {
        try {
            // Validate inputs
            String name = jTextField1.getText().trim();
            if (name.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Product name cannot be empty");
                return;
            }

            // Parse and validate price - remove peso sign and commas
            double price;
            try {
                String priceStr = jTextField2.getText().trim()
                        .replace("₱", "")
                        .replace(",", "");
                price = Double.parseDouble(priceStr);
                if (price < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(this, "Please enter a valid price");
                return;
            }

            // Parse and validate stock
            int stock;
            try {
                stock = Integer.parseInt(jTextField3.getText().trim());
                if (stock < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(this, "Please enter a valid stock number");
                return;
            }

            // Parse and validate weight - remove "kg" and commas
            double weight;
            try {
                String weightStr = jTextField4.getText().trim()
                        .replace(" kg", "")
                        .replace(",", "");
                weight = Double.parseDouble(weightStr);
                if (weight < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(this, "Please enter a valid weight");
                return;
            }

            // Prepare update query
            String query = "UPDATE products SET product_name=?, price=?, stock=?, weight=?";
            if (imageData != null) {
                query += ", image_data=?";
            }
            query += " WHERE product_name=?";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, name);
            pst.setDouble(2, price);
            pst.setInt(3, stock);
            pst.setDouble(4, weight);

            if (imageData != null) {
                pst.setBytes(5, imageData);
                pst.setString(6, originalProductName);
            } else {
                pst.setString(5, originalProductName);
            }

            // Execute update
            int result = pst.executeUpdate();
            if (result > 0) {
                JOptionPane.showMessageDialog(this, "Product updated successfully!");
                parentFrame.loadProductsTable();  // Refresh the products table
                dispose();  // Close the dialog
            } else {
                JOptionPane.showMessageDialog(this, "Failed to update product");
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,
                    "Error updating product: " + e.getMessage(),
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        }
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
        jLabel8 = new javax.swing.JLabel();
        jButton9 = new javax.swing.JButton();
        jSeparator1 = new javax.swing.JSeparator();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jSeparator2 = new javax.swing.JSeparator();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setBackground(new java.awt.Color(255, 255, 255));

        jPanel1.setBackground(new java.awt.Color(179, 1, 104));

        jLabel8.setBackground(new java.awt.Color(255, 204, 204));
        jLabel8.setOpaque(true);

        jButton9.setFont(new java.awt.Font("Segoe UI", 1, 12)); // NOI18N
        jButton9.setForeground(new java.awt.Color(179, 1, 104));
        jButton9.setText("Change Image");

        jLabel1.setFont(new java.awt.Font("SansSerif", 1, 18)); // NOI18N
        jLabel1.setForeground(new java.awt.Color(255, 255, 255));
        jLabel1.setText("Update Product");

        jLabel2.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Product Name");

        jLabel3.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(255, 255, 255));
        jLabel3.setText("Price ( ₱ )");

        jLabel4.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(255, 255, 255));
        jLabel4.setText("Stock");

        jLabel5.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(255, 255, 255));
        jLabel5.setText("Weight (kg)");

        jButton1.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jButton1.setForeground(new java.awt.Color(179, 1, 104));
        jButton1.setText("Update Product");

        jButton2.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jButton2.setForeground(new java.awt.Color(179, 1, 104));
        jButton2.setText("Cancel");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap(27, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, 442, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE)
                                .addComponent(jButton9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGap(29, 29, 29)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(jTextField1, javax.swing.GroupLayout.DEFAULT_SIZE, 298, Short.MAX_VALUE)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 95, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 95, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel5, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 95, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextField2)
                                .addComponent(jTextField3)))
                        .addComponent(jSeparator2, javax.swing.GroupLayout.PREFERRED_SIZE, 442, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 298, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 91, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                            .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(37, 37, 37))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(21, 21, 21)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(9, 9, 9)
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 20, Short.MAX_VALUE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addComponent(jSeparator2, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(20, 20, 20))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        //* Set the Nimbus look and feel */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(UpdateProductDialog.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }

        /* Create and display the dialog */
        java.awt.EventQueue.invokeLater(() -> {
            // Since this is just for testing/preview, we'll use dummy values
            UpdateProductDialog dialog = new UpdateProductDialog(
                    new javax.swing.JFrame(), // parent frame
                    true, // modal
                    "Test Product", // name
                    0.0, // price
                    0, // stock
                    0.0, // weight
                    null, // image data
                    null // connection (null for preview)
            );
            dialog.addWindowListener(new java.awt.event.WindowAdapter() {
                @Override
                public void windowClosing(java.awt.event.WindowEvent e) {
                    System.exit(0);
                }
            });
            dialog.setVisible(true);
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton9;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JSeparator jSeparator2;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    // End of variables declaration//GEN-END:variables
}
