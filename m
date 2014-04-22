From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] hugetlb_cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 14:47:42 +0800
Message-ID: <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
References: <1398144620-9630-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=1z3k3e1Hj9MWaHT4eegL4GZWZb6fptMMegY6cHVy7Hk=;
        b=Sz5NT+RonMmxWnqBSMLOQqeyLLxlxqbwjjy1waGb5fODf2mOQffxWLXXkA4ZWYV592
         LGUe9q58mcdbxJC7JEiPup/rgdLgunNB586ByMKu/4LVjq1iG1tiH1lFsy9cS9Ye64Z3
         cIjdQKMhde1RaS16EGJuQkxV7F/ep1XmgWj6KpaQ9W+dIZ51c8wNPWB+EmowXsKhgtlQ
         uij23WP7EKdlakhL4zi7pvq1iwu/B6B2jf84FMEgwWATA5oC5H7Qz1hwPyJIkxg0W97t
         wds14bbve8vNpMMTczuf/d0VemFGN1yXNPA/CVu6/d+/m5j25Y/OSfNMN8MNIV91CXk+
         4NOw==
In-Reply-To: <1398144620-9630-1-git-send-email-nasa4836@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org, Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Apr 22, 2014 at 1:30 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
>
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.
>
But other fields still missed, if any. Fair?

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/hugetlb_cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 595d7fd..b5368f8 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -405,4 +405,5 @@ struct cgroup_subsys hugetlb_cgrp_subsys = {
>         .css_alloc      = hugetlb_cgroup_css_alloc,
>         .css_offline    = hugetlb_cgroup_css_offline,
>         .css_free       = hugetlb_cgroup_css_free,
> +       .early_init     = 0,
>  };
> --
> 2.0.0-rc0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
