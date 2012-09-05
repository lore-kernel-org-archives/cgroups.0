From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:19:25 -0700
Message-ID: <20120905091925.GJ3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1CHxEmUyDGD9klRbXkctZczz3cgFF8Va97PWvdS8pFM=;
        b=dtbbOB1YseUFthtoNLEp4L87EQPrALxkZMUVqm7lsVXtwasrpvoPs1Urp64sLmiopf
         DgzutNlsyTgVLEKWxcG1WriFdfoningbt89qla2cuNxzNEdiCiRX5QgYlIT0VBhqk0FU
         k6JYfQkP6fKYNu49M7z35Rijv9Vu3tv10y5LJ5A0W7y3ao29QD/7WIfKW5xaszjSG253
         b46WV3JMKYRXB8XNgCoFifzLo+btcb0APxHVbU5oS7CmHQWQgtxbPc1d/wzZFAoZ8cZs
         E8J3NRH/KuhmS7rUw9XikfeS3nldYwAwa9liXcTIbKKkcTwu+ZpjLGVNr9T/A34tpRTG
         LISQ==
Content-Disposition: inline
In-Reply-To: <50471782.6060800-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On Wed, Sep 05, 2012 at 01:12:34PM +0400, Glauber Costa wrote:
> > No, I never counted out differing granularity.
> 
> Can you elaborate on which interface do you envision to make it work?
> They will clearly be mounted in the same hierarchy, or as said
> alternatively, comounted.

I'm not sure yet.  At the simplest, mask of controllers which should
honor (or ignore) nesting beyond the node.  That should be
understandable enough.  Not sure whether that would be flexible enough
yet tho.  In the end, they should be comounted but again I don't think
enforcing comounting at the moment is a step towards that.  It's more
like a step sideways.

Thanks.

-- 
tejun
