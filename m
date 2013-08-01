From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Date: Thu, 1 Aug 2013 08:08:55 -0400
Message-ID: <20130801120855.GA24966@htj.dyndns.org>
References: <51F8DA99.3010303@huawei.com>
 <20130731113619.GL2810@htj.dyndns.org>
 <51F9B5BD.2070502@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TQTL/V2myZqT2NYh/0Qc7/MNVq++7I7WeuMYy6v5SmE=;
        b=EtC4avAULy6jD7Avdpwx1Q1N7Rrzz4FjDUPwmN/sbwHv84rgkWRpxYWrPkUrML+azz
         DmbqlKAGMlSyxtJ9LgwlLreFK5nD9rv9M7U9WNxHvk4tuc89mDKNSpvWqn3DNrkIj22I
         18Nawpni62s6f2sBBfIopAQ2Yd0F6qDTFRs00NHgusltWTSRoF0NOePOvgKC3rqkDfQk
         yv2hGV8rWke94r3rJ9QGXYMWts9WYp76mRRTY2yucm/fKvf8CoU43+VPR0MnS5yLhLFR
         PBp47NfchGQhlbW/XYNllPMt1RpHkWamDHfQIgYPvyDn9/acruGraFhFJmPHPHP7jSoY
         kOHQ==
Content-Disposition: inline
In-Reply-To: <51F9B5BD.2070502-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Aug 01, 2013 at 09:11:25AM +0800, Li Zefan wrote:
> On 2013/7/31 19:36, Tejun Heo wrote:
> > On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
> >> We can use struct cfent instead.
> >>
> >> v2:
> >> - remove cgroup_seqfile_release().
> >>
> >> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Applied to libata/for-3.12.
> > 
> 
> libata? I hope you didn't. :)

Haha, brainfart.  I did apply it to cgroup/for-3.12. :)

-- 
tejun
