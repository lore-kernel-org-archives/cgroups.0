From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroups: add documentation on extended attributes
 usage
Date: Wed, 5 Sep 2012 15:49:22 -0700
Message-ID: <20120905224922.GA29092@google.com>
References: <20120905183132.806473183@napanee.usersys.redhat.com>
 <20120905183133.162440150@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=d+8GYMHrSyhn0z20WjZ+frTmPi/wy1Qr9IGn00gCx+s=;
        b=qeUm0sT1gYlbZjr2IXy7B/5FS1onzRpQu+4leTsvuUFL+hX+1M6BwwR/XudPG53h8W
         i0eWDnOfD4lcqrnhwc7iCo2Nxye9gQQdn3++vdMnTqKziZSNV5of7QjdU3I/Are8gpKQ
         4sBCrRFvleocdjVlh4brZyQxqJJYq2ooX+B2hfpOlEWljjoOjLtBbSmpWhsJAIer+TBZ
         0wto4n54eP2T/JECP3hy+8TRpp7JXTrr/gmTTssKYZXDq6Yh1c9wpgDPUg1VIb1UdEsZ
         uVm39GFT7CJcHmrWOAvtAYfyEwguL5GxBM8YBCWvMi1mljKiGBPWtPbjhIbrpPSLt2ga
         RIHg==
Content-Disposition: inline
In-Reply-To: <20120905183133.162440150-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Sep 05, 2012 at 02:31:33PM -0400, Aristeu Rozanski wrote:
>  Documentation/cgroups/00-INDEX  |    2 ++
>  Documentation/cgroups/xattr.txt |   21 +++++++++++++++++++++
>  2 files changed, 23 insertions(+)

Please put it in cgroups.txt.

Thanks.

-- 
tejun
