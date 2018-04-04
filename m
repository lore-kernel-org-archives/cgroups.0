From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: INFO: rcu detected stall in bitmap_parselist
Date: Wed, 4 Apr 2018 18:41:36 +0300
Message-ID: <20180404154136.p7aeye7657q466sq@yury-thinkpad>
References: <000000000000edc3690568cc95eb@google.com>
 <f1a0af0d-44c5-e938-b48f-0bace885f0a2@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-cavium-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TMBfLN5UlSxEt1WX81lr/sysQA/Awmwns7r6i1lhuls=;
 b=WKntmZD+AXZJSmZaSb+wqHnhU+BzMoP3DLEqFLOq4b6qcNhxmWznrAI+a85OkzUHVPl/1+iPZO43iLcCpOsooZybhQvwfc6IueROwvOewQrYtssaToTGP6QzWF2aOjEzRpaxyuA9ym4FwpDmxjCasVDSAaJwCg8q5kVRDGZaQcE=
Content-Disposition: inline
In-Reply-To: <f1a0af0d-44c5-e938-b48f-0bace885f0a2@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: syzbot <syzbot+6887cbb011c8054e8a3d@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, syzkaller-bugs@googlegroups.com, Noam Camus <noamca@mellanox.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Matthew Wilcox <mawilcox@microsoft.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Hi Tetsuo,

Thanks for the patch.

On Wed, Apr 04, 2018 at 09:21:43PM +0900, Tetsuo Handa wrote:
> Yury, are you OK with this patch?
> 
> 
> >From 7f21827cdfe9780b4949b22bcd19efa721b463d2 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Wed, 4 Apr 2018 21:12:10 +0900
> Subject: [PATCH] lib/bitmap: Rewrite __bitmap_parselist().
> 
> syzbot is catching stalls at __bitmap_parselist() [1]. The trigger is
> 
>   unsigned long v = 0;
>   bitmap_parselist("7:,", &v, BITS_PER_LONG);

Could you add this case to the test_bitmap_parselist()?

> which results in hitting infinite loop at
> 
>   while (a <= b) {
>     off = min(b - a + 1, used_size);
>     bitmap_set(maskp, a, off);
>     a += group_size;
>   }
> 
> due to used_size == group_size == 0.
> 
> Current code is difficult to read due to too many flag variables.
> Let's rewrite it.

I also don't like current implementation of bitmap_parselist(), but
discussion on new code  may take some time. Can you submit minimal
fix in separated patch to let people discuss your new implementation
without rush?

> My understanding of "range:used_size/group_size"
> is "start[-end[:used_size/group_size]]" format.
> Please check whether my understanding is correct...
 
My understanding is same. Can you add it to documentation or comment
to function?

> [1] https://syzkaller.appspot.com/bug?id=ad7e0351fbc90535558514a71cd3edc11681997a
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: syzbot <syzbot+6887cbb011c8054e8a3d@syzkaller.appspotmail.com>
> Fixes: 0a5ce0831d04382a ("lib/bitmap.c: make bitmap_parselist() thread-safe and much faster")
> Cc: Yury Norov <ynorov@caviumnetworks.com>
> Cc: Noam Camus <noamca@mellanox.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  lib/bitmap.c | 183 +++++++++++++++++++++++++----------------------------------
>  1 file changed, 78 insertions(+), 105 deletions(-)
> 
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 9e498c7..9cef440 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -485,6 +485,58 @@ int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
>  }
>  EXPORT_SYMBOL(bitmap_print_to_pagebuf);
>  
> +static bool get_uint(const char **buf, unsigned int *res)
> +{
> +	const char *p = *buf;
> +
> +	if (!isdigit(*p))
> +		return false;
> +	*res = simple_strtoul(p, (char **) buf, 10);

In comment to simple_strtoul(): "This function is obsolete. Please
use kstrtoul instead."

> +	return p < *buf;
> +}
> +
> +static int __bitmap_parse_one_chunk(const char *buf, unsigned long *maskp,
> +				    const unsigned int nmaskbits)
> +{
> +	unsigned int start;
> +	unsigned int end;
> +	unsigned int group_size;
> +	unsigned int used_size;
> +
> +	while (*buf && isspace(*buf))
> +		buf++;
> +	if (!get_uint(&buf, &start))
> +		return -EINVAL;
> +	if (*buf == '-') {
> +		buf++;
> +		if (!get_uint(&buf, &end) || start > end)
> +			return -EINVAL;
> +		if (*buf == ':') {
> +			buf++;
> +			if (!get_uint(&buf, &used_size) || *buf++ != '/' ||
> +			    !get_uint(&buf, &group_size) ||
> +			    used_size > group_size)
> +				return -EINVAL;

So this is still not safe against "1-10:0/0", or I miss something?
(This is another testcase we should add to test_bitmap.c)

> +		} else {
> +			group_size = used_size = end - start + 1;
> +		}
> +	} else {
> +		end = start;
> +		group_size = used_size = 1;
> +	}
> +	if (end >= nmaskbits)
> +		return -ERANGE;

This should be checked before we start parsing group, to avoid useless work.

> +	while (start <= end) {
> +		const unsigned int bits = min(end - start + 1, used_size);
> +
> +		bitmap_set(maskp, start, bits);
> +		start += group_size;
> +	}
> +	while (*buf && isspace(*buf))
> +		buf++;
> +	return *buf ? -EINVAL : 0;
> +}
> +
>  /**
>   * __bitmap_parselist - convert list format ASCII string to bitmap
>   * @buf: read nul-terminated user string from this buffer
> @@ -511,113 +563,34 @@ int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
>   *   - ``-ERANGE``: bit number specified too large for mask
>   */
>  static int __bitmap_parselist(const char *buf, unsigned int buflen,
> -		int is_user, unsigned long *maskp,
> -		int nmaskbits)
> +			      const int is_user, unsigned long *maskp,
> +			      const int nmaskbits)
>  {
> -	unsigned int a, b, old_a, old_b;
> -	unsigned int group_size, used_size, off;
> -	int c, old_c, totaldigits, ndigits;
> -	const char __user __force *ubuf = (const char __user __force *)buf;
> -	int at_start, in_range, in_partial_range;
> -
> -	totaldigits = c = 0;
> -	old_a = old_b = 0;
> -	group_size = used_size = 0;
> +	int err = 0;
>  	bitmap_zero(maskp, nmaskbits);
> -	do {
> -		at_start = 1;
> -		in_range = 0;
> -		in_partial_range = 0;
> -		a = b = 0;
> -		ndigits = totaldigits;
> -
> -		/* Get the next cpu# or a range of cpu#'s */
> -		while (buflen) {
> -			old_c = c;
> -			if (is_user) {
> -				if (__get_user(c, ubuf++))
> -					return -EFAULT;
> -			} else
> -				c = *buf++;
> -			buflen--;
> -			if (isspace(c))
> -				continue;
> -
> -			/* A '\0' or a ',' signal the end of a cpu# or range */
> -			if (c == '\0' || c == ',')
> -				break;
> -			/*
> -			* whitespaces between digits are not allowed,
> -			* but it's ok if whitespaces are on head or tail.
> -			* when old_c is whilespace,
> -			* if totaldigits == ndigits, whitespace is on head.
> -			* if whitespace is on tail, it should not run here.
> -			* as c was ',' or '\0',
> -			* the last code line has broken the current loop.
> -			*/
> -			if ((totaldigits != ndigits) && isspace(old_c))
> -				return -EINVAL;
> -
> -			if (c == '/') {
> -				used_size = a;
> -				at_start = 1;
> -				in_range = 0;
> -				a = b = 0;
> -				continue;
> -			}
> -
> -			if (c == ':') {
> -				old_a = a;
> -				old_b = b;
> -				at_start = 1;
> -				in_range = 0;
> -				in_partial_range = 1;
> -				a = b = 0;
> -				continue;
> -			}
> -
> -			if (c == '-') {
> -				if (at_start || in_range)
> -					return -EINVAL;
> -				b = 0;
> -				in_range = 1;
> -				at_start = 1;
> -				continue;
> -			}
> -
> -			if (!isdigit(c))
> -				return -EINVAL;
> -
> -			b = b * 10 + (c - '0');
> -			if (!in_range)
> -				a = b;
> -			at_start = 0;
> -			totaldigits++;
> -		}
> -		if (ndigits == totaldigits)
> -			continue;
> -		if (in_partial_range) {
> -			group_size = a;
> -			a = old_a;
> -			b = old_b;
> -			old_a = old_b = 0;
> -		} else {
> -			used_size = group_size = b - a + 1;
> -		}
> -		/* if no digit is after '-', it's wrong*/
> -		if (at_start && in_range)
> -			return -EINVAL;
> -		if (!(a <= b) || !(used_size <= group_size))
> -			return -EINVAL;
> -		if (b >= nmaskbits)
> -			return -ERANGE;
> -		while (a <= b) {
> -			off = min(b - a + 1, used_size);
> -			bitmap_set(maskp, a, off);
> -			a += group_size;
> -		}
> -	} while (buflen && c == ',');
> -	return 0;
> +	while (buflen && !err) {
> +		char *cp;
> +		char tmpbuf[256];
> +		unsigned int size = min(buflen,
> +					(unsigned int) sizeof(tmpbuf) - 1);
> +
> +		if (!is_user)
> +			memcpy(tmpbuf, buf, size);
> +		else if (copy_from_user(tmpbuf, (const char __user __force *)
> +					buf, size))
> +			return -EFAULT;

This is not safe against this:
"[250 whitespaces] 567-890:123/456"

And it will be Schlemiel the painter's-styled algorithm for input like:
"1,2,3,4, ... ,98,99,100". 

I think we need something like __bitmap_parse_get_chunk() to copy
coma-separated substrings.

> +		tmpbuf[size] = '\0';
> +		cp = strchr(tmpbuf, ',');
> +		if (cp) {
> +			*cp = '\0';
> +			size = cp - tmpbuf + 1;
> +		} else if (size != buflen)
> +			return -EINVAL; /* Chunk too long. */
> +		buflen -= size;
> +		buf += size;
> +		err = __bitmap_parse_one_chunk(tmpbuf, maskp, nmaskbits);
> +	}
> +	return err;
>  }
>
>  int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
> -- 
> 1.8.3.1

Thanks,
Yury
