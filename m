From: Tejun Heo <tj@kernel.org>
Subject: Re: CGroups: idr_remove called for id=65536 which is not allocated.
Date: Wed, 13 Jul 2016 11:22:26 -0400
Message-ID: <20160713152226.GC4065@mtj.duckdns.org>
References: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pD1UydokkkzBsDZ4b4dyfqP5cVK82QOV6E8m4ZcZHsI=;
        b=uo6N9SSLnQJJS8XMtSq0y15SZ3wOH9npAOhZ4x+pYpl7qzBQY2fdDnecDLwDJ2uh6L
         ewx7++UADI8887G1ZNw/14fBv+3ojbHutMW5XPAL/zc2ZB4QdG71hoUIZU4wrspccXJG
         3iCK6n7/vtMTcgCHx3Yn9o7JFFpVQj4HJiLLFXbGq7zPvId3JK2qXoBm7oU10ark/ajA
         zuciKMoZ3J/7YPkzF5mK4IdwXaUYjF+qqp49b7+MSl9E5gOHP/QAZC1omhp1f4DaYCLi
         dtKD10R+14uqb0IXizQFpQwdfwdNPH9jGEDBx9NGSEvdcMYNC8/Z4hqujdIP8fNChqmS
         6cWg==
Content-Disposition: inline
In-Reply-To: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Garcia <john.garcia@mesosphere.io>
Cc: gregkh@linuxfoundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

Hello,

On Wed, Jul 13, 2016 at 06:31:18AM -0700, John Garcia wrote:
> Hi esteemed kernel devs! Please be sure to CC answers to me personally
> so they're flagged for my attention.
> 
> I've filed https://bugzilla.kernel.org/show_bug.cgi?id=124641 in
> Bugzilla, so I'll try not to repeat too many key details here; GKH has
> asked that I bring the conversation to email, LKML, and the cgroups
> list.
> 
> Long story short, we see the behavior described in this LKML thread
> http://lkml.iu.edu/hypermail/linux/kernel/1606.2/00736.html and (we
> think) addressed by the patch therein - memory cgroups don't seem to
> be automatically garbage collected during runtime and must be manually
> released to allow space for new cgroups after the 65336 limit is
> reached. At this time, the only way we've found to release them is to

It's not that memcg doesn't gc the dead csses but that the memory
lying around keeps pinning the memcg struct down.  There's nothing
wrong with it.  As soon as there's memory pressure, the memory will
get reclaimed and the memcg structs will be freed.  The problem is
caused by the memcg struct keeping pinning memcg id which is a pretty
limited resource.  The above patch fixes the issue by the lifetime of
decoupling memcg id from that of memcg struct.

> send echo 1 > /proc/sys/vm/drop_caches
> to the kernel. The title of this message is the dmesg line we
> typically see in machines that have breached the limit, and are trying
> in vain to remove a cgroup beyond the 65536 ceiling.

The idr_remove message is from a bug in creation failure path.  It is
harmless and removed by b00c52dae6d9 ("cgroup: remove redundant
cleanup in css_create").

> We've asked CoreOS to cut a build with the patch from LKML and we'll
> test it shortly to see if it alleviates the problem. We'll update this
> list with results of testing against that patch and also test against
> a 4.6.x kernel as soon as possible. Let us know if you need the full
> stack trace or other diagnostic info.

With the patches backported, there shouldn't be any more issues.  If
you encounter any more issues with it, please let us know.

Thanks.

-- 
tejun
