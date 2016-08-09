From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] kernfs: make kernfs_path*() behave in the style of
 strlcpy()
Date: Tue, 9 Aug 2016 10:33:05 -0500
Message-ID: <20160809153305.GB30775@mail.hallyn.com>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
 <1470720204-4605-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470720204-4605-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> kernfs_path*() functions always return the length of the full path but
> the path content is undefined if the length is larger than the
> provided buffer.  This makes its behavior different from strlcpy() and
> requires error handling in all its users even when they don't care
> about truncation.  In addition, the implementation can actully be
> simplified by making it behave properly in strlcpy() style.
> 
> * Update kernfs_path_from_node_locked() to always fill up the buffer
>   with path.  If the buffer is not large enough, the output is
>   truncated and terminated.
> 
> * kernfs_path() no longer needs error handling.  Make it a simple
>   inline wrapper around kernfs_path_from_node().
> 
> * sysfs_warn_dup()'s use of kernfs_path() doesn't need error handling.
>   Updated accordingly.
> 
> * cgroup_path()'s use of kernfs_path() updated to retain the old
>   behavior.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---
>  fs/kernfs/dir.c        | 61 ++++++++++++++------------------------------------
>  fs/sysfs/dir.c         |  6 ++---
>  include/linux/cgroup.h |  7 +++++-
>  include/linux/kernfs.h | 21 ++++++++++++-----
>  4 files changed, 42 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index e57174d..09242aa 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -110,8 +110,9 @@ static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
>   * kn_to:   /n1/n2/n3         [depth=3]
>   * result:  /../..
>   *
> - * return value: length of the string.  If greater than buflen,
> - * then contents of buf are undefined.  On error, -1 is returned.
> + * Returns the length of the full path.  If the full length is equal to or
> + * greater than @buflen, @buf contains the truncated path with the trailing
> + * '\0'.  On error, -errno is returned.
>   */
>  static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
>  					struct kernfs_node *kn_from,
> @@ -119,9 +120,8 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
>  {
>  	struct kernfs_node *kn, *common;
>  	const char parent_str[] = "/..";
> -	size_t depth_from, depth_to, len = 0, nlen = 0;
> -	char *p;
> -	int i;
> +	size_t depth_from, depth_to, len = 0;
> +	int i, j;
>  
>  	if (!kn_from)
>  		kn_from = kernfs_root(kn_to)->kn;
> @@ -131,7 +131,7 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
>  
>  	common = kernfs_common_ancestor(kn_from, kn_to);
>  	if (WARN_ON(!common))
> -		return -1;
> +		return -EINVAL;
>  
>  	depth_to = kernfs_depth(common, kn_to);
>  	depth_from = kernfs_depth(common, kn_from);
> @@ -144,22 +144,16 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
>  			       len < buflen ? buflen - len : 0);
>  
>  	/* Calculate how many bytes we need for the rest */
> -	for (kn = kn_to; kn != common; kn = kn->parent)
> -		nlen += strlen(kn->name) + 1;
> -
> -	if (len + nlen >= buflen)
> -		return len + nlen;
> -
> -	p = buf + len + nlen;
> -	*p = '\0';
> -	for (kn = kn_to; kn != common; kn = kn->parent) {
> -		size_t tmp = strlen(kn->name);
> -		p -= tmp;
> -		memcpy(p, kn->name, tmp);
> -		*(--p) = '/';
> +	for (i = depth_to - 1; i >= 0; i--) {
> +		for (kn = kn_to, j = 0; j < i; j++)
> +			kn = kn->parent;

This is O(n^2) where n is the path depth.  It's not a hot path, though, do
we care?
