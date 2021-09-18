From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v7 07/12] fs/kernfs/symlink.c: replace S_IRWXUGO with 0777 on kernfs_create_link()
Date: Fri, 17 Sep 2021 22:04:25 -0700
Message-ID: <20210918050430.3671227-8-mcgrof@kernel.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4KirTB7VY9SdAqVf3vHSLLAh3zhrPlo2Qk48uTXZukk=; b=M3gNwW/3XmET0QXwkUtZBLl6u4
        1fhEGEUQYKWh1X+hingr7d2CTVDYbiRek1XUcdyeBFWAiEbwmnTaHcf4pG0J8eBpZqwJ/ReN3sVOE
        32PgvSegTrsYy03OREjJ6df1LfJNeQkCN1tgGm1WtJ3M7qDHpd/C/gXqFqMbgk5Ut156Ho/9dYhYZ
        MGyA1mY6eCMqFgK7R+67kowY9YQ5cj/wHw0K7qStNPM17qReXj01yjEFO1Z/fnvn2ce4+61Kkem7v
        4gPMReMbfYNTTV6q9QQ6pI7eunfeQiipgjUp/AH/X3gEyUNKAIQ/YObz9XQRsgbynjlTUtuSFCdg5
        JAbmMSUg==;
In-Reply-To: <20210918050430.3671227-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org
Cc: rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@ACULAB.COM, bvanassche@acm.org, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, daniel.vetter@ffwll.ch, bhelgaas@google.com, kw@linux.com, dan.j.williams@intel.c

If one ends up extending this line checkpatch will complain about the
use of S_IRWXUGO suggesting it is not preferred and that 0777
should be used instead. Take the tip from checkpatch and do that
change before we do our subsequent changes.

This makes no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/kernfs/symlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index c8f8e41b8411..19a6c71c6ff5 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -36,8 +36,7 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 		gid = target->iattr->ia_gid;
 	}
 
-	kn = kernfs_new_node(parent, name, S_IFLNK|S_IRWXUGO, uid, gid,
-			     KERNFS_LINK);
+	kn = kernfs_new_node(parent, name, S_IFLNK|0777, uid, gid, KERNFS_LINK);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.30.2

