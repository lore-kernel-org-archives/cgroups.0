From: Greg Thelen <gthelen@google.com>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Thu, 05 Feb 2015 14:05:19 -0800
Message-ID: <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
References: <20150130044324.GA25699@htj.dyndns.org> <xr93h9v8yfrv.fsf@gthelen.mtv.corp.google.com> <20150130062737.GB25699@htj.dyndns.org> <20150130160722.GA26111@htj.dyndns.org> <54CFCF74.6090400@yandex-team.ru> <20150202194608.GA8169@htj.dyndns.org> <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com> <20150204170656.GA18858@htj.dyndns.org> <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com> <20150205131514.GD25736@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:message-id:in-reply-to:date
         :mime-version:content-type;
        bh=ym0/ChSKQpTnOxMG74iaGc8QWMj20oKr1NEhKQ1HqyY=;
        b=RybUuVB2yetUwQQ37hTVILa8PA0KQY2hIwcxJRERwzjSmWrvFS6Zqer+1UI4wlNQrg
         g1K/XCtbnIc9kdbKdEpDozCsdwTObj3R7kl0+pscrqD4/EaCYsbtfIp6fLdbHFdqcD2U
         Tp7PQN/hf/IfLZB9ppXHVlecf0hT5FzIA6tHvdVwtgXnVXOisDrD8SSrc+4XT8dW50dr
         rzgjvvBggn0zuUTNL6s7lKeDgozBU1XucEHvPbJt1YQrKuAqmhyHbhLl82B1O7cAPuet
         PajhpRX3KOzKOCZ8muG5FjuOQHybWtrEa7Xpgqi9JmQAOAKp0/fLjZ1PDjO9iqdiipGu
         jc8A==
In-reply-to: <20150205131514.GD25736@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>


On Thu, Feb 05 2015, Tejun Heo wrote:

> Hello, Greg.
>
> On Wed, Feb 04, 2015 at 03:51:01PM -0800, Greg Thelen wrote:
>> I think the linux-next low (and the TBD min) limits also have the
>> problem for more than just the root memcg.  I'm thinking of a 2M file
>> shared between C and D below.  The file will be charged to common parent
>> B.
>> 
>> 	A
>> 	+-B    (usage=2M lim=3M min=2M)
>> 	  +-C  (usage=0  lim=2M min=1M shared_usage=2M)
>> 	  +-D  (usage=0  lim=2M min=1M shared_usage=2M)
>> 	  \-E  (usage=0  lim=2M min=0)
>> 
>> The problem arises if A/B/E allocates more than 1M of private
>> reclaimable file data.  This pushes A/B into reclaim which will reclaim
>> both the shared file from A/B and private file from A/B/E.  In contrast,
>> the current per-page memcg would've protected the shared file in either
>> C or D leaving A/B reclaim to only attack A/B/E.
>> 
>> Pinning the shared file to either C or D, using TBD policy such as mount
>> option, would solve this for tightly shared files.  But for wide fanout
>> file (libc) the admin would need to assign a global bucket and this
>> would be a pain to size due to various job requirements.
>
> Shouldn't we be able to handle it the same way as I proposed for
> handling sharing?  The above would look like
>
>  	A
>  	+-B    (usage=2M lim=3M min=2M hosted_usage=2M)
>  	  +-C  (usage=0  lim=2M min=1M shared_usage=2M)
>  	  +-D  (usage=0  lim=2M min=1M shared_usage=2M)
>  	  \-E  (usage=0  lim=2M min=0)
>
> Now, we don't wanna use B's min verbatim on the hosted inodes shared
> by children but we're unconditionally charging the shared amount to
> all sharing children, which means that we're eating into the min
> settings of all participating children, so, we should be able to use
> sum of all sharing children's min-covered amount as the inode's min,
> which of course is to be contained inside the min of the parent.
>
> Above, we're charging 2M to C and D, each of which has 1M min which is
> being consumed by the shared charge (the shared part won't get
> reclaimed from the internal pressure of children, so we're really
> taking that part away from it).  Summing them up, the shared inode
> would have 2M protection which is honored as long as B as a whole is
> under its 3M limit.  This is similar to creating a dedicated child for
> each shared resource for low limits.  The downside is that we end up
> guarding the shared inodes more than non-shared ones, but, after all,
> we're charging it to everybody who's using it.
>
> Would something like this work?

Maybe, but I want to understand more about how pressure works in the
child.  As C (or D) allocates non shared memory does it perform reclaim
to ensure that its (C.usage + C.shared_usage < C.lim).  Given C's
shared_usage is linked into B.LRU it wouldn't be naturally reclaimable
by C.  Are you thinking that charge failures on cgroups with non zero
shared_usage would, as needed, induce reclaim of parent's hosted_usage?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
