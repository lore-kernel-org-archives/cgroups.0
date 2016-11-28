From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove unused 'struct cpuset*' variable
Date: Mon, 28 Nov 2016 15:53:58 -0500
Message-ID: <20161128205358.GA7363@htj.duckdns.org>
References: <kirtika@chromium.org>
 <1480049712-17224-1-git-send-email-kirtika@chromium.org>
 <5837D01C.1070803@huawei.com>
 <4410043.lxDXIbV3iK@wuerfel>
 <5838DA80.6040208@huawei.com>
 <20161128073709.GA14835@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kaQTsYuHq/d5iyO0hBaVncpcuj+O2NeO0MoMt6c+7N4=;
        b=wt21fPa+Q7ASPOmpGoyt2CJf1O9tJr1XLvvxLcgEqn9TeU71zm3VfdAPhKeyDEUkuu
         9QC44f1ycjptpCAzXGVN2eJ+xqIbPXxZ7yKPKjY9VFZTVbglq7ehfrXb0hWK/7JYHG0t
         RtbNlksktNkyP1rHRqs6/p7kA2TIGDxzF7H7L7FCfMOtcDAZ43qk7DDwq/MosWRDHPG9
         EJy59RWZknofsjcnCFbXZl8NO4A2iGnPJok/iaeh4Q2MKuUz9xQqThqvurHQ6RUHr7OP
         ZOYNTTT8vj5wVRLvi1bKeHLat09joavu2zddazliMiN64UwgCKpJSXkPX0T37nxKN94K
         2dEg==
Content-Disposition: inline
In-Reply-To: <20161128073709.GA14835-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Kirtika Ruchandani <kirtika-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Nov 28, 2016 at 08:37:09AM +0100, Michal Hocko wrote:
> I would disagree here. Randomly picking up fixes just because they are
> Fixing some commit is just too dangerous for the stable trees. Fixes tag
> should tell what was the culprit of the issue fixed by the patch,
> nothing more and nothing less.

Logically, I agree but then the only time I used the Fixes tag is when
I was tagging patches for stable and I can imagine people grepping for
the tag to backport.  Also, given that the offending commit is already
referenced in the description, the tag doesn't make much difference to
human beings.  I don't think it's a big deal either way but am more
inclined to follow Li's suggestion here given that he is maintaining
stable trees.

Thanks.

-- 
tejun
