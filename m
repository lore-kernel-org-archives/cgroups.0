From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-4.3] blkcg: blkcg_policy methods cleanup
Date: Tue, 7 Jul 2015 16:00:47 -0400
Message-ID: <20150707200047.GC23362@mtj.duckdns.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QUJqUxUS/Fe7zC0nmwEdjsaqSVkoyYbF/TcC1UObxvw=;
        b=p/nLLQB2F3Y2KRmeB5CNw0sAtDqPYg42z4De0Wg8vvuLsGRfUVV331c02MaZ/NUVod
         1MP3N+ixQxhvkEI5FEGEB+hhDGhb5kqwT9R5OQPXGB1/IRLxM+NCC/daHtBTd3asEA+H
         hobr6YCSnUpy/BRFGe7qcgy+BvoE8JfHG0f+bhaGq6rb96JYl6TZ3G4SQqo7KlHGUza4
         1UTYfmLb1KhWhG9kgPFzGVtKQYM/8JDaMIGnAP97t62cW98/j5+N16bu0HKXIiVElWEK
         CX/LeXx/0fWuFXfv0IYZxxdk77zLsC3rSEtkeUtm4oIY3KB/UHCSARywld+VIpQ6Wnf5
         0kww==
Content-Disposition: inline
In-Reply-To: <1436284293-4666-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Jul 07, 2015 at 11:51:26AM -0400, Tejun Heo wrote:
> This is v2 of blkcg_policy methods cleanup patchset.  Changes from the
> last take [L] are
> 
> * Rebased on top of v4.2-rc1 and other pending patches.  v4.2-rc1
>   added a patch to add per-blkcg policy data which is allocated by
>   blkcg core as per-blkcg_gq policy data was before this patchset
>   making the two inconsistent.  I'll follow up with per-blkcg policy
>   data update.

While updating per-blkcg policy data handling, I discovered a couple
bugs in policy data handling which should be backported through
-stable.  I'll put those earlier in the series and repost this
patchset.  Please ignore this one for now.

Thanks.

-- 
tejun
