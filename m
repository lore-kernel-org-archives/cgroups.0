From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Fri, 26 Apr 2013 11:37:41 -0700
Message-ID: <20130426183741.GA25940@mtj.dyndns.org>
References: <20130421022321.GE19097@mtj.dyndns.org>
 <20130421124554.GA8473@dhcp22.suse.cz>
 <20130422043939.GB25089@mtj.dyndns.org>
 <20130422151908.GF18286@dhcp22.suse.cz>
 <20130422155703.GC12543@htj.dyndns.org>
 <20130422162012.GI18286@dhcp22.suse.cz>
 <20130422183020.GF12543@htj.dyndns.org>
 <20130423092944.GA8001@dhcp22.suse.cz>
 <20130423170900.GH12543@htj.dyndns.org>
 <20130426115120.GG31157@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=42nMl9vLFJqugHdm0zlx8lhx2PLBOW4KYw1204WKBZU=;
        b=nbuHTb4S1EFwVX9YQpAHP1Y0VFH2HkCTQq6SR5O24ujn4KtWK2CDoPKtX4irzADgnB
         xC0DgPd8juZKqlIyzdrWa6TZ5T12muVpiHjq3MxZOQANqB+sO2dZKQZkN6oUziED3T+f
         G8uQGegdJKdVIuGWOkbh4a7vpiB7Ri7kD7QjFE5C0Er1IzKGWAPiv2GW3xmlDxjqAkpb
         JbYirtvSeuz7X6EKfTOm5xNDQC7GNc72DFrakgU1lHoBLxwqqQU+spvVrYzTqEad+jzm
         doKNcIKIjTbAXWM9lAvbJ65uegx/oRNZmU+f7hCW5QGSljtM0/sdPMN/6ms1iHtgzZl0
         +YJA==
Content-Disposition: inline
In-Reply-To: <20130426115120.GG31157-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey,

On Fri, Apr 26, 2013 at 01:51:20PM +0200, Michal Hocko wrote:
> Maybe I should have been more explicit about this but _yes I do agree_
> that a separate limit would work as well. I just do not want to

Heh, the point was more about what we shouldn't be doing, but, yeah,
it's good that we at least agree on something.  :)

> Anyway, I will think about cons and pros of the new limit. I think we
> shouldn't block the first 3 patches in the series which keep the current
> semantic and just change the internals to do the same thing. Do you
> agree?

As the merge window is coming right up, if it isn't something super
urgent, can we please hold it off until after the merge window?  It
would be really great if we can pin down the semantics of the knob
before doing anything.  Please.  I'll think / study more about it in
the coming weeks.

Thanks.

-- 
tejun
