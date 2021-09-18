From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v7 08/12] fs/sysfs/dir.c: replace S_IRWXU|S_IRUGO|S_IXUGO with 0755 sysfs_create_dir_ns()
Date: Fri, 17 Sep 2021 22:04:26 -0700
Message-ID: <20210918050430.3671227-9-mcgrof@kernel.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eU0Ovi0loMOt90ZC44OHIOcp0Nb8ys+AmBqPx+DEBFM=; b=EGRNR6XrGcu/Y2nvAt7CVjcqem
        d8ejBdVzVQkuLTb+tpdo/Smw903x9MvFfm/2gItW/7msby9ii/pgTa5xf0SPDjnVXRPyXm2J51q58
        T52goTmkokygeDNOJwPEu79YH2R4gWk8rtbTvumS9ffE9ibqRbl/+Mz1G/vL/sMMXm1+rkkCbGlto
        qPfl2oOV4tj53k99WTBILq+O2vGtMNm8h12a8ELjAhmN0ccVn85dq+a6hkh4KD6J/VFFfmDcpGrIo
        HAtsArgtGtFtbKzMQBxPsuyhvHljGPjSd5f38Wd4Rj9d1M1nhO2t4/Wm9cmzFfqsU6eoEKlowafZJ
        7m6bs+iA==;
In-Reply-To: <20210918050430.3671227-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org
Cc: rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@ACULAB.COM, bvanassche@acm.org, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, daniel.vetter@ffwll.ch, bhelgaas@google.com, kw@linux.com, dan.j.williams@intel.c

If one ends up expanding on this line checkpatch will complain that the
combination S_IRWXU|S_IRUGO|S_IXUGO should just be replaced with the
octal 0755. Do that.

This makes no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/sysfs/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 59dffd5ca517..b6b6796e1616 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -56,8 +56,7 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 
 	kobject_get_ownership(kobj, &uid, &gid);
 
-	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
-				  S_IRWXU | S_IRUGO | S_IXUGO, uid, gid,
+	kn = kernfs_create_dir_ns(parent, kobject_name(kobj), 0755, uid, gid,
 				  kobj, ns);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
-- 
2.30.2

