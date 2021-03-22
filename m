From: Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 03/11] security: commoncap: fix -Wstringop-overread warning
Date: Mon, 22 Mar 2021 17:02:41 +0100
Message-ID: <20210322160253.4032422-4-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429036;
        bh=yFqEt0Vza9xx1ZEH6vpmadF/s9WD+9cr+PvfYFx1jTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnY2VvcIHWNR00CmYsS8o9sdpXW8IfqlUTn3pfDogyHxX/SIITlr8SG6GxkT3eSRZ
         a7K8jLXsPna4Mm190+MpWcuBICb/n+i193Sgx5UJVnr/NQaks4zNGBOOkdJN7kk+Zx
         IrtL2gHR1/fBjD9NvgLiYwkQqQ/EKWhfodExGrNMHcxDZouSH1dybJZC/EbBnOcXm9
         XQLG8dt1bjMaDOofLpAx013Fhy9k111G7DuVnc/32l3avRksgUDzsBf0x12znYeUYk
         RAdBhG+/y/EhxEsBwjpyhm77vbHfFV6Wbj7ETM5qbIRB/4/X2e34tKnfe8hgDnqlGY
         gToo1OwJ8lpqg==
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Ning Sun <ning.sun@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Kalle Valo <kvalo@codeaurora.org>, Simon Kelley <simon@thekelleys.org.uk>, James Smart <james.smart@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>, Imre Deak <imre.deak@intel.com>, linux-arm-kernel@lists.infradead.org, tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian.braune>

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 introdces a harmless warning for cap_inode_getsecurity:

security/commoncap.c: In function ‘cap_inode_getsecurity’:
security/commoncap.c:440:33: error: ‘memcpy’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
  440 |                                 memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem here is that tmpbuf is initialized to NULL, so gcc assumes
it is not accessible unless it gets set by vfs_getxattr_alloc().  This is
a legitimate warning as far as I can tell, but the code is correct since
it correctly handles the error when that function fails.

Add a separate NULL check to tell gcc about it as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 security/commoncap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 28f4d25480df..9a36ed6dd737 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -400,7 +400,7 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
 				      &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0)
+	if (ret < 0 || !tmpbuf)
 		return ret;
 
 	fs_ns = inode->i_sb->s_user_ns;
-- 
2.29.2

