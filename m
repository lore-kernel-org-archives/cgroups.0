From: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts/tags.sh: add regular expression replacement pattern
 for memcg
Date: Wed, 16 Apr 2014 23:24:06 +0200
Message-ID: <534EF4F6.8000900@suse.cz>
References: <1397134732-29106-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397134732-29106-1-git-send-email-nasa4836@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, michael.opdenacker@free-electrons.com, tkhai@yandex.ru, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Dne 10.4.2014 14:58, Jianyu Zhan napsal(a):
> Sorry, the comment in previous patch is somewhat misguiding, this patch
> replaces that one.
>  
> Currently, no regular expression replacement patterns for PageCgroup*
> flag-ops are defined, which causes quite a few pain while reading code. 
> Just get rid of it.
> 
> Also, add a comment to inform people to add pattern for whatever new
> flag-ops they add.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  include/linux/page_cgroup.h | 6 ++++++
>  scripts/tags.sh             | 8 ++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 777a524..9c60b77 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -44,6 +44,12 @@ static inline void __init page_cgroup_init(void)
>  struct page_cgroup *lookup_page_cgroup(struct page *page);
>  struct page *lookup_cgroup_page(struct page_cgroup *pc);
>  
> +/*
> + * Note, whenever you add a *PCGFLAG operation here, please add a
> + * regular expression replacement pattern in scripts/tags.sh
> + * to inform our friendly and smart tags generator.
> + */
> +
>  #define TESTPCGFLAG(uname, lname)			\

Cgroup hackers - OK to add the above comment? It does not look like new
macros are being defined here on a weekly basis...


>  static inline int PageCgroup##uname(struct page_cgroup *pc)	\
>  	{ return test_bit(PCG_##lname, &pc->flags); }
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 58c4559..c0d52d1 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -171,12 +171,16 @@ exuberant()
>  	--regex-c++='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
>  	--regex-c++='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'		\
>  	--regex-c++='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'			\
> +	--regex-c++='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
>  	--regex-c++='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
>  	--regex-c++='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
> +	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
>  	--regex-c++='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
>  	--regex-c++='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
> +	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
>  	--regex-c++='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
>  	--regex-c++='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
> +	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
>  	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
>  	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'		\
>  	--regex-c++='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\

Please do not interleave the new defines with the <linux/page-flags.h>
defines.

Michal

> @@ -229,12 +233,16 @@ emacs()
>  	--regex='/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
>  	--regex='/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'	\
>  	--regex='/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
> +	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
>  	--regex='/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
>  	--regex='/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'	\
> +	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
>  	--regex='/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
>  	--regex='/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
> +	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
>  	--regex='/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'	\
>  	--regex='/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
> +	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
>  	--regex='/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
>  	--regex='/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
>  	--regex='/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
> 
