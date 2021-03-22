From: Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 08/11] atmel: avoid gcc -Wstringop-overflow warning
Date: Mon, 22 Mar 2021 17:02:46 +0100
Message-ID: <20210322160253.4032422-9-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429107;
        bh=hZ+CAtng3yIYZIb+ah3e8qtw8iX8HVHsX0ExOcLMkVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwkY1GeSKE6uqnx1AxEi3VFdRhYPg81cUVXGmS7VFECNmiWnHG9H8Xs03DE5r5UkI
         2VYRrKWZEbiYE/8Go+UBgggdeU5IHX8PCQyERsMz4uhXvD8S/WDGEhcAqel5lYAhxx
         GH5OrCzsuWJ7MemQavOxq36ZBrGw8QsN0rHVPucenBu12gisEUNifGSz6+0j2xJ9ZZ
         bEVaUqft+/YBHP8/oDZqfcdvztMrcHT8BJQ3udH192n6G7X4gUnHIGCuLP1ptF/QU4
         TnlXa1Qe8PUzWprVm8njgDc/yGpNfz20AWAFmYDGGOfZtOuyJUs4ZC7Fgr12Ezshk/
         OxLRDx1pnNY1A==
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>, Simon Kelley <simon@thekelleys.org.uk>, Kalle Valo <kvalo@codeaurora.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Ning Sun <ning.sun@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, James Smart <james.smart@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge@hallyn.com>, Imre Deak <imre.deak@intel.com>, linux-arm-kernel@lists.infradead.org, tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, Lee Jones <lee.jones@linaro.org>, Pascal Terjan <pterjan@google.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 notices that the fields as defined in the ass_req_format
structure do not match the actual use of that structure:

cc1: error: writing 4 bytes into a region of size between 18446744073709551613 and 2 [-Werror=stringop-overflow=]
drivers/net/wireless/atmel/atmel.c:2884:20: note: at offset [4, 6] into destination object ‘ap’ of size 6
 2884 |                 u8 ap[ETH_ALEN]; /* nothing after here directly accessible */
      |                    ^~
drivers/net/wireless/atmel/atmel.c:2885:20: note: at offset [4, 6] into destination object ‘ssid_el_id’ of size 1
 2885 |                 u8 ssid_el_id;
      |                    ^~~~~~~~~~

This is expected here because the actual structure layout is variable.
As the code does not actually access the individual fields, replace
them with a comment and fixed-length array so prevent gcc from
complaining about it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/atmel/atmel.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 707fe66727f8..ff9152d600e1 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -2881,13 +2881,18 @@ static void send_association_request(struct atmel_private *priv, int is_reassoc)
 	struct ass_req_format {
 		__le16 capability;
 		__le16 listen_interval;
-		u8 ap[ETH_ALEN]; /* nothing after here directly accessible */
-		u8 ssid_el_id;
-		u8 ssid_len;
-		u8 ssid[MAX_SSID_LENGTH];
-		u8 sup_rates_el_id;
-		u8 sup_rates_len;
-		u8 rates[4];
+		u8 ssid_el[ETH_ALEN + 2 + MAX_SSID_LENGTH + 2 + 4];
+		/*
+		 * nothing after here directly accessible:
+		 *
+		 * u8 ap[ETH_ALEN];
+		 * u8 ssid_el_id;
+		 * u8 ssid_len;
+		 * u8 ssid[MAX_SSID_LENGTH];
+		 * u8 sup_rates_el_id;
+		 * u8 sup_rates_len;
+		 * u8 rates[4];
+		 */
 	} body;
 
 	header.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
@@ -2907,13 +2912,13 @@ static void send_association_request(struct atmel_private *priv, int is_reassoc)
 
 	body.listen_interval = cpu_to_le16(priv->listen_interval * priv->beacon_period);
 
+	ssid_el_p = body.ssid_el;
 	/* current AP address - only in reassoc frame */
 	if (is_reassoc) {
-		memcpy(body.ap, priv->CurrentBSSID, ETH_ALEN);
-		ssid_el_p = &body.ssid_el_id;
+		memcpy(ssid_el_p, priv->CurrentBSSID, ETH_ALEN);
+		ssid_el_p += ETH_ALEN;
 		bodysize = 18 + priv->SSID_size;
 	} else {
-		ssid_el_p = &body.ap[0];
 		bodysize = 12 + priv->SSID_size;
 	}
 
-- 
2.29.2

