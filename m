From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH v3 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Thu, 12 Mar 2020 13:03:14 -0700
Message-ID: <20200312200317.31736-2-dxu@dxuuu.xyz>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=oNeib/zSSc/Ml
        kvsC3EDiuR3sxV3CwZWI/SYjFLvvIM=; b=cIkAcMhS3F04KFXhXECfvihZaf8SY
        lPxqdOqgjYNwFGO9F5UFYat0HY5wgx6OW9YDVKODzOcamBNuRf/kw83vHAvatcnn
        2HmDqZ+OlK3yfReHpgShA/10rN2lvn71rZZ8rjfiVoJHROORqAtZf+opPmyxnUaY
        3fw5n5SZP7/tQHVCy2Vo2aUafyrv4otknmDIUa22Mn1A5bRdRq0ovugHYUodg4wd
        sIoICvzv2uEic/aE9lkSWANZmYgCoygfY3CLbKdJg37+KyNM7wBBnIJ4So9aFuqv
        /H0Pk1edYdg4OwDiZqF2Ui+9iEpqB19qnPaPYtDjmmcn+P5EdQP50ozQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=oNeib/zSSc/MlkvsC3EDiuR3sxV3CwZWI/SYjFLvvIM=; b=vyqXOR93
        COmOhbX1RIN751Q5MG7SCcb03XDg3em6YYUQyr8Kd5M461/4aEC5mJrT2lGFiUtG
        y7FDLsoh4+qQGwsXSKwMKu4KYfsj7slwQ0RdEE1hiTVoQDwVhOu/Z6uD7/Z4nItZ
        6SLYaIU/YliddTr0RbbAocMOOoIparKJCDVvhV70o+2ojBT5PQRIeAeBnzUAp9Xk
        kFSz3Kn6XolT2J0bEywrHa9mN53odhfbcN+sTduAqGfKFUTeIpLWla9vZ2UEIMpp
        rCpo+umVFTPRBYkg2aSTrPcTbi3rDYPUajO83kpUrG/bpECikiTrzDvaDixm33Vi
        k4ySUJvfmisOsw==
In-Reply-To: <20200312200317.31736-1-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, viro@zeniv.linux.org.uk
Cc: Daniel Xu <dxu@dxuuu.xyz>, shakeelb@google.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

xattr values have a 64k maximum size. This can result in an order 4
kmalloc request which can be difficult to fulfill. Since xattrs do not
need physically contiguous memory, we can switch to kvmalloc and not
have to worry about higher order allocations failing.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 fs/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 90dd78f0eb27..0d3c9b4d1914 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
 	if (len < sizeof(*new_xattr))
 		return NULL;
 
-	new_xattr = kmalloc(len, GFP_KERNEL);
+	new_xattr = kvmalloc(len, GFP_KERNEL);
 	if (!new_xattr)
 		return NULL;
 
@@ -882,7 +882,7 @@ int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 
 		new_xattr->name = kstrdup(name, GFP_KERNEL);
 		if (!new_xattr->name) {
-			kfree(new_xattr);
+			kvfree(new_xattr);
 			return -ENOMEM;
 		}
 	}
@@ -912,7 +912,7 @@ int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 	spin_unlock(&xattrs->lock);
 	if (xattr) {
 		kfree(xattr->name);
-		kfree(xattr);
+		kvfree(xattr);
 	}
 	return err;
 
-- 
2.21.1

