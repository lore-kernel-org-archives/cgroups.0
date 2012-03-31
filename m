From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Sat, 31 Mar 2012 09:31:58 -0700
Message-ID: <20120331163158.GB2557@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <20120330222936.GI28934@google.com>
 <4F76FC27.3050709@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GXXaDeFUV2CUV0APzaXqyTxbd2FCSBs2jKYXU3dHQEw=;
        b=KhW4JB3rg1C3rZy0FmSO1HtzP9AVcvup3dEzwrd6WrIMXOdYLEQjbcKNsIze9O1wS+
         AYDcPWrkhUwWKVK3L10V4TfyoxAv5HKEKwFnrT96ORORsb4a+G8pD90bQyVe+Cr/3++m
         8QmMt52iTGuUBVVGYlfDeqC0/p23WGUZ8csE2yk605wfNVD3tWZlxzDsQzITjJfQ/Wvs
         /S4FICT2iqY27AAP/ZmGSYSHvKlhu6Gm7dsdUOggUkyYutAP2N5xtSWgu7LaM0Bcyo7d
         qrJG/2VTQO1M69D6/wMWs6tH72/3ho7nIdLxZvHH+mbLc9ZLnvdGcxihwQkqyqn6PPiP
         M52w==
Content-Disposition: inline
In-Reply-To: <4F76FC27.3050709-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

On Sat, Mar 31, 2012 at 08:44:23PM +0800, Li Zefan wrote:
> I've gone through the whole patchset, feel free to add my acks.

I'll add acked-by's to all patches including the remount deprecation
patch and start cgroup/for-3.5 branch.  If there's any disagreement,
please scream.

Thanks.

-- 
tejun
