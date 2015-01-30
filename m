From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Fri, 30 Jan 2015 11:07:22 -0500
Message-ID: <20150130160722.GA26111@htj.dyndns.org>
References: <20150130044324.GA25699@htj.dyndns.org>
 <xr93h9v8yfrv.fsf@gthelen.mtv.corp.google.com>
 <20150130062737.GB25699@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dLVdT0bD0RxTLwRZKDVmf1uWJ5gHkhuKQnsEt2qAXSk=;
        b=PHiF69Mr0x6zFQ0yGD7SbpQgrFwO3v0hkTASgmMzUCopU9v5J6Fkq3Wth2Zo4Z37CV
         Q14esaaFMzoRwBlq8TSC9PDATV8Xv1dF1lGq9//UA15pbk36P2gFyfrSWSHk6g++kN60
         DuMAvz8kbbboJfy+FslER6SHdmxUiDimo765vxkvRdonjdAwbhDwra7EeVmRhboBfC3T
         ReBbG2++OASKCip2fD4rWh9zgFzrajI4Hl6TnQyy+WdeuNf/HwRjWKnCGp6KU01hChSo
         7huKpPVI3y0rBn6W0bdxgSeEEZitHAoV2pMCgl6u7BVwOxn9wEa5Lm+jYLdVr+x/WziG
         mWJg==
Content-Disposition: inline
In-Reply-To: <20150130062737.GB25699-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Konstantin Khebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

Hey, again.

On Fri, Jan 30, 2015 at 01:27:37AM -0500, Tejun Heo wrote:
> The previous behavior was pretty unpredictable in terms of shared file
> ownership too.  I wonder whether the better thing to do here is either
> charging cases like this to the common ancestor or splitting the
> charge equally among the accessors, which might be doable for ro
> files.

I've been thinking more about this.  It's true that doing per-page
association allows for avoiding confronting the worst side effects of
inode sharing head-on, but it is a tradeoff with fairly weak
justfications.  The only thing we're gaining is side-stepping the
blunt of the problem in an awkward manner and the loss of clarity in
taking this compromised position has nasty ramifications when we try
to connect it with the rest of the world.

I could be missing something major but the more I think about it, it
looks to me that the right thing to do here is accounting per-inode
and charging shared inodes to the nearest common ancestor.  The
resulting behavior would be way more logical and predicatable than the
current one, which would make it straight forward to integrate memcg
with blkcg and writeback.

One of the problems that I can think of off the top of my head is that
it'd involve more regular use of charge moving; however, this is an
operation which is per-inode rather than per-page and still gonna be
fairly infrequent.  Another one is that if we move memcg over to this
behavior, it's likely to affect the behavior on the traditional
hierarchies too as we sure as hell don't want to switch between the
two major behaviors dynamically but given that behaviors on inode
sharing aren't very well supported yet, this can be an acceptable
change.

Thanks.

-- 
tejun
