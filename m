From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CGroups: idr_remove called for id=65536 which is not allocated.
Date: Thu, 14 Jul 2016 11:30:43 -0400
Message-ID: <20160714153043.GN15005@htj.duckdns.org>
References: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
 <20160713152226.GC4065@mtj.duckdns.org>
 <CAO2SnQ-fEXH3xpAV3x61h1ewp8j8EYGPQTuhviE6=4Z2=KHvcA@mail.gmail.com>
 <20160713201417.GA29670@mtj.duckdns.org>
 <20160713230226.GA7075@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PNxGgW+Fm+AIMQ5RQxfbsNEh/BzagptOoaX3C6Mnxwc=;
        b=cpN72jvcNCz1KD0WF7vdK/ymiqXW5RsuGtJT25wskOzMvon5jl2yApKk68NJeEPz1r
         P8udShEpjrG/BZaGTjX+YlpOP3nJQIqme8rgpZmMXvUfolxpTwu+Si9YZHeQpqnr/lMp
         R7cUsgi2jcBGRe9avoRhBzWDRxt5vRIkPl1Au73+hP1LcDqlqUlH9/nzy9deHrbcBY9g
         KtUPXTfqzxrQhswOsvBagnQ0CoFyV0mKCU+RQ6d7Lf+RQiEl8d+UGI7cIjiwppV2qysh
         hvQRi4x49nc9umVXHpez+Tu9jiuw8XHG/507IeUAG8T1QdlE0887Z+TEThjVxQJH10fx
         GA2w==
Content-Disposition: inline
In-Reply-To: <20160713230226.GA7075-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: John Garcia <john.garcia-+FQPb40bacfW/loQ7rKezA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Greg.

On Thu, Jul 14, 2016 at 08:02:26AM +0900, Greg KH wrote:
> On Wed, Jul 13, 2016 at 04:14:17PM -0400, Tejun Heo wrote:
> > On Wed, Jul 13, 2016 at 01:10:05PM -0700, John Garcia wrote:
> > > Hi Tejun, thanks for the response!
> > > 
> > > It sounds like everything is good then, is it likely this will get
> > > backported to the next LTS 4.4 kernel?
> > 
> > Yeah, it should.
> 
> Which commits exactly should be backported?  I'll be glad to do that...

Hmmm... actually, the patches aren't tagged for -stable.  The patches
are queued in mm and the relevant patches are

 mm: memcontrol: fix cgroup creation failure after many small jobs
 mm: memcontrol: fix cgroup creation failure after many small jobs fix
 
Johannes will ping Andrew so that they can out for v4.8 with -stable
cc'd.

Thanks.

-- 
tejun
