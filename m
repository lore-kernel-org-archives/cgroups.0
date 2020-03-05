From: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Thu,  5 Mar 2020 13:16:29 -0800
Message-ID: <20200305211632.15369-2-dxu@dxuuu.xyz>
References: <20200305211632.15369-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=ux2TDbebxuteV
        tSjPdu5QbynJeWd1LoiKrJmNCdzdIM=; b=GPK4Fjmyow4b3ce4kYCAUlYC8pM5w
        S6doYRhglZqqqTQ8e4SnwlqC72XpMG+wH5+g5fvKILm4d7P1x/8qzwnFkO7fATxY
        XSCCKQkYuU3QjUtEIxXyAKsLC8y49lD8Vc7n+4hosNaaMHby6nZ1cEzEiZNleRWp
        VExbaKmXKBtyDsRpn8M2zyhjyDbzQsPK1SYYga+5Q4G/ONgN/2er1ZghXm25CdJz
        B/66CVk1f8VmlSEBowHV33Ij3+OrzVLxz7Eo6RLwj3HYZpy7xyaGa8zX/hUBAK/e
        Zljcpt/lXRiO5GGxOGz498ePOhomk3Qb4CEO2MHasA6YUdQo8iZRLLxQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ux2TDbebxuteVtSjPdu5QbynJeWd1LoiKrJmNCdzdIM=; b=OahLzm5/
        l9ZomGwWpevlziasrzFQPQc80mfo6qhSO7nvBJZ5IFXZomkMr/qbAdybc2RspJwl
        Sk5X4YwkQhBS3ulFV/cZKr2mGxNd5jgSmKUdyfS3/CTL/vGqlWBzWdNUNubFO58t
        P35KYmtKQXPjLsiw4TBCvjEi424qD2w7JDThS1VFTmhULS7qqI0g5yiF9AyBQTdn
        0a3SWYmxS9i8XY1rLtlEV9OjmzwXOnZKHZO/u4qULhr9ttZT73hL7RYk7UN295YX
        CWT9OYqxheGNH/ERun/QIzFbQiTbLpqp9rD9jnpD3t15RiI9fvYilLVhmJ0WomFU
        19CjkzIqH81BdQ==
In-Reply-To: <20200305211632.15369-1-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

It's not really necessary to have contiguous physical memory for xattr
values. We no longer need to worry about higher order allocations
failing with kvmalloc, especially because the xattr size limit is at
64K.

Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
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

