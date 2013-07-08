From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Mon, 8 Jul 2013 10:56:07 -0700
Message-ID: <20130708175607.GB18600@mtj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
 <20130708175201.GB9094@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PsUaHDXYXBvdC5ctzYwiKMGwZckPqVyCUHSRzV/383g=;
        b=pq7Rw6Z8ZZxConX71CQ93v7QxcKc5bUJnWj7IAFXaL8DYd3XP82ky+zHHHcp8TaqTE
         n4V7Vlo3lmljAnQew80B2OtOTZuB+vu1Xik/TszP6w2ym8rsjFXm1R8gntBluX+upXnU
         uAR4Ee5tFFdhLs6QfnkxdKXw/DFbiNWRBlIcxPeehmUplXFMNl2ieQ5mO9a/MYFHDq0y
         8HzYs2rzL/GFXMyPUtxMMSHKXRV3S7hbo3GpPwZETXJ0x70XVTeTzIsRJeIo3/vzMWah
         OKpsWVMHF+x9iLkyGP5ZqiC/zLRILfyjninPdNuIsl7PVt8Zdj1M1+tvmPOjGttQJVFV
         YJNQ==
Content-Disposition: inline
In-Reply-To: <20130708175201.GB9094@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

Hello, Vivek.

On Mon, Jul 08, 2013 at 01:52:01PM -0400, Vivek Goyal wrote:
> > Again, a problem to be fixed in the stack rather than patching up from
> > up above.  The right thing to do is to propagate pressure through bdi
> > properly and let whatever is backing the bdi generate appropriate
> > amount of pressure, be that disk or network.
> 
> Ok, so use network controller for controlling IO rate on NFS? I had
> tried it once and it did not work. I think it had problems related
> to losing the context info as IO propagated through the stack. So
> we will have to fix that too.

But that's a similar problem we have with blkcg anyway - losing the
dirtier information by the time writeback comes down through bdi.  It
might not be exactly the same and might need some impedance matching
on the network side but I don't see any fundamental differences.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
