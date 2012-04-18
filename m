From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: Use scnprintf instead of sprintf
Date: Wed, 18 Apr 2012 15:36:23 -0700
Message-ID: <20120418153623.9582dffa.akpm@linux-foundation.org>
References: <20120416161354.b967790c.akpm@linux-foundation.org>
	<1334729756-10212-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334729756-10212-1-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

On Wed, 18 Apr 2012 11:45:56 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This make sure we don't overflow.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/memcontrol.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 519d370..0ccf934 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5269,14 +5269,14 @@ static void mem_cgroup_destroy(struct cgroup *cont)
>  }
>  
>  #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> -static char *mem_fmt(char *buf, unsigned long n)
> +static char *mem_fmt(char *buf, int size, unsigned long hsize)
>  {
> -	if (n >= (1UL << 30))
> -		sprintf(buf, "%luGB", n >> 30);
> -	else if (n >= (1UL << 20))
> -		sprintf(buf, "%luMB", n >> 20);
> +	if (hsize >= (1UL << 30))
> +		scnprintf(buf, size, "%luGB", hsize >> 30);
> +	else if (hsize >= (1UL << 20))
> +		scnprintf(buf, size, "%luMB", hsize >> 20);
>  	else
> -		sprintf(buf, "%luKB", n >> 10);
> +		scnprintf(buf, size, "%luKB", hsize >> 10);
>  	return buf;
>  }

We could use snprintf() here too but it doesn't seem to matter either
way.  I guess we _should_ use snprintf as it causes less surprise.

--- a/mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix
+++ a/mm/memcontrol.c
@@ -4037,7 +4037,7 @@ static ssize_t mem_cgroup_read(struct cg
 		BUG();
 	}
 
-	len = scnprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
+	len = snprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
 	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
 }
 /*
@@ -5199,11 +5199,11 @@ static void mem_cgroup_destroy(struct cg
 static char *mem_fmt(char *buf, int size, unsigned long hsize)
 {
 	if (hsize >= (1UL << 30))
-		scnprintf(buf, size, "%luGB", hsize >> 30);
+		snprintf(buf, size, "%luGB", hsize >> 30);
 	else if (hsize >= (1UL << 20))
-		scnprintf(buf, size, "%luMB", hsize >> 20);
+		snprintf(buf, size, "%luMB", hsize >> 20);
 	else
-		scnprintf(buf, size, "%luKB", hsize >> 10);
+		snprintf(buf, size, "%luKB", hsize >> 10);
 	return buf;
 }
 

It is regrettable that your mem_fmt() exists, especially within
memcontrol.c - it is quite a generic thing.  Can't we use
lib/string_helpers.c:string_get_size()?  Or if not, modify
string_get_size() so it is usable here?

Speaking of which,

From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: lib/string_helpers.c: make arrays static

Moving these arrays into static storage shrinks the kernel a bit:

   text    data     bss     dec     hex filename
    723     112      64     899     383 lib/string_helpers.o
    516     272      64     852     354 lib/string_helpers.o

Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 lib/string_helpers.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-make-arrays-static lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-make-arrays-static
+++ a/lib/string_helpers.c
@@ -23,15 +23,15 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
+	static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
 				   "EB", "ZB", "YB", NULL};
-	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
+	static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
 				 "EiB", "ZiB", "YiB", NULL };
-	const char **units_str[] = {
+	static const char **units_str[] = {
 		[STRING_UNITS_10] =  units_10,
 		[STRING_UNITS_2] = units_2,
 	};
-	const unsigned int divisor[] = {
+	static const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
_
