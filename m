From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH] xattr: fix uninitialized out-param
Date: Wed,  8 Apr 2020 23:27:29 -0700
Message-ID: <20200409062729.1658747-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=nbW/mYyxCyeed5rv4GZbVacG2k
        0bT79z98b3D3IVtpE=; b=o3wnUT/NIdcXucDC+oPeVeHdDloFV2fLRhtZOfwxq3
        BM/XZpC8i3dIfyQYmR2eXYvqPIMGNKVgJpd9svucsYjM8A62vxo7SJU/+XS7vV2W
        4Chl5XxBg5E9cQMB8f+yYFn52A1bUYux7aTbSWJH2gFDKwcodZdaP2JWkfzGRKXg
        U9jNjF+YCGU97UclZnkDvduezNGTqcwu4ujst9F6mbAXnO9iNJ8CEKIr1j96kNJO
        qvPekNvUUj78bvSB8zdSVUU39MKht9a04Xz+sc14MU9Jfd9Ru/L6TUrIulUCZczS
        VLGgD6jJv3k1s5f6yGJdoUKU9nb1emkYunjrDRcQ5LlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nbW/mYyxCyeed5rv4
        GZbVacG2k0bT79z98b3D3IVtpE=; b=JQyN2cNHj1D15pTE4hrx6GwNzAvFqsa12
        aVoxUMs0idPFsqgqYDeQ57gyffMNIuB2MgvzYOG6D5WYyE7Fn0BYeciZG2PsjYLw
        qwq27QQvY4pNT9PA39TYSzrt38pvJMBAFLimqT7t6r0LgmU9d2eNcS/NyxcyXFoU
        iH4PZB4aF5ogRP9+nRAcSuv7J0YZw3gbyDHEPB3MO1Bm3suiO43UB6/2At4NOPA1
        kPJyMgBdUs3L72LOMM0G6iOy/aFh3BQyomUnWjlQMt/LqBGIQ14Z0yNt4W1bzA0u
        POu9lglI7eUi0d79BxDzldf2axc38K6RsbWxB2x+Mpjjw5d5x3+Aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, viro@zeniv.linux.org.uk
Cc: Daniel Xu <dxu@dxuuu.xyz>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

`removed_sized` isn't correctly initialized (as the doc comment
suggests) on memory allocation failures. Fix by moving initialization up
a bit.

Fixes: 0c47383ba3bd ("kernfs: Add option to enable user xattrs")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---

I'm sending this through the cgroup tree b/c the original patchset went
through it. I don't believe the patchset has made its way into mainline
yet. Hopefully this is ok.

 fs/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index e13265e65871..91608d9bfc6a 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -876,6 +876,9 @@ int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 	struct simple_xattr *new_xattr = NULL;
 	int err = 0;
 
+	if (removed_size)
+		*removed_size = -1;
+
 	/* value == NULL means remove */
 	if (value) {
 		new_xattr = simple_xattr_alloc(value, size);
@@ -914,9 +917,6 @@ int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		list_add(&new_xattr->list, &xattrs->head);
 		xattr = NULL;
 	}
-
-	if (removed_size)
-		*removed_size = -1;
 out:
 	spin_unlock(&xattrs->lock);
 	if (xattr) {
-- 
2.26.0

