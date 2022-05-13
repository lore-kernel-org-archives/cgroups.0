From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kseltest/cgroup: Make test_stress.sh work if run
 interactively
Date: Fri, 13 May 2022 09:34:10 -1000
Message-ID: <Yn6ysifWwBF6xVTa@slm.duckdns.org>
References: <20220513190928.676841-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7BSLd/9FfqODWm0XMu152wdT1waWblg0wKPb9L2tj+0=;
        b=pmakHJ5ObblxYg6DTbIX+0AwpSDprJ9K8Ncuq6QLao0GXk4/q16Voz3zpKXpb0W2u6
         Pu5NbuNDkxRvOS18/sNZpwZB19RXH9FGnf0Sm4Q6sGhFZTXCWDhRGujVu5yKBPEPfxj6
         qKdUBcFxZhLw7gw5O8SVi3TjHjuCxnLpTosqA8Yyyob1/KHvdjkTRbW1pBrXHRpOLVXD
         vxmiofElROpWqRQ3t7pPuAuebzYFlIs7lUIqwebZqCz2b9ehrNtPB2KHc5uJZW8TVSq4
         vD3MP5l0axv6GrIlB2jK0WgZkMCBotNKjrwiw89UmaKN+qydKWEYQ2Y79Mel44fCxSo6
         6+aQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220513190928.676841-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Fri, May 13, 2022 at 03:09:28PM -0400, Waiman Long wrote:
> Commit 54de76c01239 ("kselftest/cgroup: fix test_stress.sh to use OUTPUT
> dir") changes the test_core command path from . to $OUTPUT. However,
> variable OUTPUT may not be defined if the command is run interactively.
> Fix that by using ${OUTPUT:-.} to cover both cases.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.19.

Thanks, much appreciated.

-- 
tejun
