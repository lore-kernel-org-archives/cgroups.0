From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Mon, 29 Jul 2019 21:26:19 -0700
Message-ID: <201907292117.DA40CA7D@keescook>
References: <20190729151346.9280-1-hslester96@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+uAEwHCS/q5YqbTZfM9UhcffVFTLKHWKlvMKu9AlaN4=;
        b=EsXmEMrAKLXYhP9zY31O+/h2ZdkuRU0uxUsvt12z/dYH/onDFgVEw8/psz+asNdBYU
         nFXBcaiag1L68Tv6zpHm7dfIu0NIX/b28PPUvE9EqMHFn//8WEUWABDEeEqYk5Fghedc
         pEQppssDC1/AlpgweEINkqIDwRAPLQbsEmQA0=
Content-Disposition: inline
In-Reply-To: <20190729151346.9280-1-hslester96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chuhong Yuan <hslester96@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Laura Abbott <labbott@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>

On Mon, Jul 29, 2019 at 11:13:46PM +0800, Chuhong Yuan wrote:
> strncmp(str, const, len) is error-prone.
> We had better use newly introduced
> str_has_prefix() instead of it.

Wait, stop. :) After Laura called my attention to your conversion series,
mpe pointed out that str_has_prefix() is almost redundant to strstarts()
(from 2009), and the latter has many more users. Let's fix strstarts()
match str_has_prefix()'s return behavior (all the existing callers are
doing boolean tests, so the change in return value won't matter), and
then we can continue with this replacement. (And add some documentation
to Documenation/process/deprecated.rst along with a checkpatch.pl test
maybe too?)

Actually I'd focus first on the actually broken cases first (sizeof()
without the "-1", etc):

$ git grep strncmp.*sizeof | grep -v -- '-' | wc -l
17

I expect the "copy/paste" changes could just be a Coccinelle script that
Linus could run to fix all the cases (and should be added to the kernel
source's list of Coccinelle scripts). Especially since the bulk of the
usage pattern are doing literals like this:

arch/alpha/kernel/setup.c:   if (strncmp(p, "mem=", 4) == 0) {

$ git grep -E 'strncmp.*(sizeof|, *[0-9]*)' | wc -l
2565

And some cases are weirdly backwards:

tools/perf/util/callchain.c:  if (!strncmp(tok, "none", strlen(tok))) {

-Kees

> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  kernel/cgroup/rdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
> index ae042c347c64..fd12a227f8e4 100644
> --- a/kernel/cgroup/rdma.c
> +++ b/kernel/cgroup/rdma.c
> @@ -379,7 +379,7 @@ static int parse_resource(char *c, int *intval)
>  			return -EINVAL;
>  		return i;
>  	}
> -	if (strncmp(value, RDMACG_MAX_STR, len) == 0) {
> +	if (str_has_prefix(value, RDMACG_MAX_STR)) {
>  		*intval = S32_MAX;
>  		return i;
>  	}
> -- 
> 2.20.1
> 

-- 
Kees Cook
