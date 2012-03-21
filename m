From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] get rid of populate for memcg
Date: Wed, 21 Mar 2012 09:19:03 -0700
Message-ID: <20120321161903.GA5272@google.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
 <1332262256-13407-5-git-send-email-glommer@parallels.com>
 <20120320183149.GB20832@google.com>
 <4F6984F3.2010009@parallels.com>
 <20120321160610.GA4246@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wvPTr+Hg/WX9rP90+jmTbQqO4jAeCgmBr5dtb5ZXEzs=;
        b=QCS8cWBy2eVkGR2L6tWo2WciqHD/z6BOkD45ttHG2gTKXFGG/K8fXjdCTubeXAs3HG
         PLQQ6OlQOO0EhLqMUWs6Z31DnmZkUZPaWJv5g3PvFa37zMB8y9cTRosjt653CCQK/Lqk
         Yr9okYZWhg5DiEC0RAykTvPw9sIJhG7XH6jeValwpLYHrB+QRex99aJY41nXBMpsDadn
         YKBBEkL4MX00+qSZWr/9z8u7XnwwvwlgBgjTnRCxSDmu+gB7yLQSOW0PuJli55w474yi
         m/r0xRI6mdfWenAORfPer8oGTQhwbzUMXzArOy0htMJAlu/UR9M7UYCqb5n/NpYhESN3
         hdig==
Content-Disposition: inline
In-Reply-To: <20120321160610.GA4246-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, Mar 21, 2012 at 09:06:10AM -0700, Tejun Heo wrote:
> I don't quite get why a protocol module would be loaded but not
> reigstered.  Do we actually have cases like that?  I know it's
> mechanically possible but don't think there's any actual use case or
> existing code which does that, so no need to worry about them.

Also, if a proto is registered from a module, it's gotta have a
module_init() which registers proto, right?  Then, the right thing to
do would be just "register proto; register cftypes;" in the function
and the reverse of that in module_exit().

-- 
tejun
