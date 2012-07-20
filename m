From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Don't drop the cgroup_mutex in cgroup_rmdir
Date: Fri, 20 Jul 2012 13:05:42 -0700
Message-ID: <20120720200542.GD21218@google.com>
References: <87ipdjc15j.fsf@skywalker.in.ibm.com>
 <1342706972-10912-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120719165046.GO24336@google.com>
 <1342799140.2583.6.camel@twins>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=m9nWbWgRECxXLq0YuRR6n6izGdWLKOfKKtgBgNOz064=;
        b=elVloE87594nU0a7CTMj/wTDTLGS8U7nacwTtAJH+2Fl7Zdq+QFiFxVER/4n9h5SAT
         vyU6SPm/kXEa6a1w2hae2q/qBNCKNvI+sG70wsWuMGJfuqSr2OtApDYppR+pyPkl6n5n
         md3x3j7QJJ6klb5DAjGp/tTEzeN49Qb2C47DoIvH5rSbCTSl/wklndTCwZED/HDq0sfY
         e32dy+jOmxezXlndrccfjjUL+y186bV+1Mu3c9k27wOZvjDV7j4xoO4a6MCDoakkYyzN
         Z2iyef777FiXyk3oZqEoIL92sXESP5yw7eOEZf7yQUOSpwfn5i2Hug/rVdBpyjNcqiDn
         UJfw==
Content-Disposition: inline
In-Reply-To: <1342799140.2583.6.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

Hey, Peter.

On Fri, Jul 20, 2012 at 05:45:40PM +0200, Peter Zijlstra wrote:
> > So, Peter, why does cpuset mangle with cgroup_mutex?  What guarantees
> > does it need?  Why can't it work on "changed" notification while
> > caching the current css like blkcg does?
> 
> I've no clue sorry.. /me goes stare at this stuff.. Looks like something
> Paul Menage did when he created cgroups. I'll have to have a hard look
> at all that to untangle this. Not something obvious to me.

Yeah, it would be great if this can be untangled.  I really don't see
any other reasonable way out of this circular locking mess.  If cpuset
needs stable css association across certain period, the RTTD is
caching the css by holding its ref and synchronize modifications to
that cache, rather than synchronizing cgroup operations themselves.

Thanks.

-- 
tejun
