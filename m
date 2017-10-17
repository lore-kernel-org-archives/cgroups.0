From: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: reorder flexible array members of struct cgroup_root
Date: Mon, 16 Oct 2017 23:33:21 -0700
Message-ID: <20171017063322.11455-1-nick.desaulniers@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sPHyyQh1LZIfh6n/GgNv9eGNwPhPNx1eEP6Z+KsCZKQ=;
        b=TE3Dvf52ZstvYQog+iXON2RV33ynZ2q1YFEWLBMETrZCqTyAgANlmsLZDY4GP3IcpB
         W6sNKZSAaWqb59ho67HHmNi2cscIYlpf+87VLeBtO03hAPG4NO0rvF79ExDA37AKWkoL
         nf41IIi8EDWPjXUypBnRDy09hlh1B27EoToic3bS4Xmrh7rNu9oMY/+etKDaa0e8zdyR
         IcD0LsT/5Fzw9Ego7PZDXLTHPzWEuDQD/pu4lpn5TiNfARbowztHSmzJxAbCAhJoIVx0
         DQH48GbZURjxahRjt8fuhiS2JaXvAaluz3kJBLJh6Gb1kv/dwhGet28OkP5jzRjETmdq
         sjsg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When compiling arch/x86/boot/compressed/eboot.c with HOSTCC=clang, the
following warning is observed:

./include/linux/cgroup-defs.h:391:16: warning: field 'cgrp' with
variable sized type 'struct cgroup' not at the end of a struct or class
is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct cgroup cgrp;
                      ^
Flexible array members are a C99 feature, but must be the last member of
a struct. Structs with flexible members composed in other structs must
also be the final members, unless using GNU C extensions.

struct cgroup_root's member cgrp is a struct cgroup, struct cgroup's
member ancestor_ids is a flexible member.

Signed-off-by: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Alternatively, we could:
* Not use flexible array members. The flexible array members and allocation
  strategy, added in commit b11cfb5807e30 mentions the hot path, so this is
  likely not an option?
* Disable this warning for HOSTCC==clang.  I'd rather not, since there's
  nothing really requiring the use of this particular GNU C extension here,
  or specific location of the member cgrp within struct cgroup_root AFAICT.

 include/linux/cgroup-defs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ade4a78a54c2..2ef256932bf3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -387,9 +387,6 @@ struct cgroup_root {
 	/* Unique id for this hierarchy. */
 	int hierarchy_id;
 
-	/* The root cgroup.  Root is destroyed on its release. */
-	struct cgroup cgrp;
-
 	/* for cgrp->ancestor_ids[0] */
 	int cgrp_ancestor_id_storage;
 
@@ -410,6 +407,9 @@ struct cgroup_root {
 
 	/* The name for this hierarchy - may be empty */
 	char name[MAX_CGROUP_ROOT_NAMELEN];
+
+	/* The root cgroup.  Root is destroyed on its release. */
+	struct cgroup cgrp;
 };
 
 /*
-- 
2.11.0
