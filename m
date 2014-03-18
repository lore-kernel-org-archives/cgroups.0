From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix a failure path in create_css()
Date: Tue, 18 Mar 2014 11:24:45 -0400
Message-ID: <20140318152445.GA3642@htj.dyndns.org>
References: <53280BAC.5060404@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Csls4x7HC5fksAdMkf6JSQFaKdX7qb8rlEiZ9n42Zvk=;
        b=M7mogHz3f1sO0G9joWkyIbF4n20XEtYAJGNnW01RAnNGF3TWlGm+i/8kO3c1dUZhs+
         NQ2RWu6DbtiiEeAKiaasUwoNZ5BlO8fLur4RCsAzpLtnSWRqbPWv0gpYXVRJa1D44YI0
         S332ov6caQnlX0r7Euza9h9uYFTfIudB7YC/juNybodHC5J5YPLR5SdETaeP7j7+IUSF
         +WtwX5aDgEtot4MBl/u0ZcYZE5MSyDxtQD7CYLnzJio7h+C+ScbAaG90MnsQcvaW+cbd
         SdK/7GOpc2xyXgXSQqwQRPl85qucKFED6THL7NLvUj/wvfG9BEVJo7dnfU4oCjVrE0sb
         PR6g==
Content-Disposition: inline
In-Reply-To: <53280BAC.5060404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 18, 2014 at 05:02:36PM +0800, Li Zefan wrote:
> If online_css() fails, we should remove cgroup files belonging
> to css->ss.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to libata/for-3.14-fixes.

Thanks.

-- 
tejun
