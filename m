From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup 1/2] cgroup: move module ref handling into
 rebind_subsystems()
Date: Tue, 16 Jul 2013 05:29:49 -0600
Message-ID: <20130716112949.GB22821@mtj.dyndns.org>
References: <20130629041231.GA31353@htj.dyndns.org>
 <20130712203817.GI23680@mtj.dyndns.org>
 <51E3645A.6080404@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ES99n+9Yu7hiEB7PzYnJt2eEelhx8/ub/piGJpsHjiE=;
        b=TPl3Cf4KcxLKHN5Yql59kkFpwG1k8MwOmXrtyAb2XMlWoiwXzStezOK7miTrtMKtuU
         ZlOasVOazKb+S/zZThczvv8mkHOWxCLcLIMLvBPmjUrTld9+BolLxc7NGtqCwxzs6lz1
         58kdTuOJ4A7LKgAt85bmuInwF02FCw41G6BWgW2+7DHOyOGmOmj3iLIu4g664Qt9EZOs
         H4TWG2QGHW1y6RnYhW6NxArbfFXBA9LRJmiSJC1U4r3HdD8hLAjRgZPCWsp/7DSQVKLX
         skzqSJRgA4RiLAZbKVrA04EDYbVh/DfZ2PCxywpl1x4TI+XaWcVAT9M73vs+TfWNstF1
         /asQ==
Content-Disposition: inline
In-Reply-To: <51E3645A.6080404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 15, 2013 at 10:54:18AM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.12.  BTW, I'm traveling and will be pretty
slow to respond this week.

Thanks!

-- 
tejun
