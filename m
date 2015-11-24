From: Tejun Heo <tj@kernel.org>
Subject: Re: RFC rdma cgroup
Date: Tue, 24 Nov 2015 10:47:45 -0500
Message-ID: <20151124154745.GK17033@mtj.duckdns.org>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=A1rSiEoW2TNMN6xUiiaktS66bD6gnuMpxuwji1S/Ubw=;
        b=H5FLkd0uUESgVFXxu7UJTi+VSqxiRwNvSfAPUFOtPL9SMmXHlQR8kjc3eYWSh48fnF
         3CLv791beLYFJLY0XlBBMS2s9znbgfOMOkNSINb2fvclJzaW2ahnLcu0RIk/ipDFvV8+
         fBcDrRmxWIs3kloGAXLA74lPu71Qc0DksHLJx596EBPTYQho71W0uZzaSkBWFvKtZzkG
         d9YIO2MPjUiqBKaQfx7175NJ03qlO/yxaO1B6BN9QfszaTpMwvRfCqAMZzasa3JW+Xrf
         CVUjaS/2pQJHCp0v5ZQ+nUWolpLM96W2Q508ODMU5hjl2hxmCKDjXGImC8JySuooPbKi
         nOrA==
Content-Disposition: inline
In-Reply-To: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Liran Liss <liranl@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>

Hello, chiming in late.

On Wed, Oct 28, 2015 at 01:59:15PM +0530, Parav Pandit wrote:
> Design guidelines:
> -----------------------
> 1. There will be new rdma cgroup for accounting rdma resources
> (instead of extending device cgroup).
> Rationale: RDMA tracks different type of resources and it functions
> differently than device cgroup. Though device cgroup could have been
> extended for more generic nature, community feels that its better to
> create RDMA cgroup, which might have more features than just resource
> limit enforcement in future.

Yeap, it should definitely be separate from device cgroup.

> 2. RDMA cgroup will allow resource accounting, limit enforcement on
> per cgroup, per rdma device basis (instead of resource limiting across
> all devices).
> Rationale: this give granular control when multiple devices exist in the system.
> 
> 3. Resources are not defined by the RDMA cgroup. Resources are defined
> by RDMA/IB subsystem and optionally by HCA vendor device drivers.
> Rationale: This allows rdma cgroup to remain constant while RDMA/IB
> subsystem can evolve without the need of rdma cgroup update. A new
> resource can be easily added by the RDMA/IB subsystem without touching
> rdma cgroup.

I'm *extremely* uncomfortable with this.  Drivers for this sort of
higher end devices tend to pull a lot of stunts for better or worse
and my gut feeling is that letting low level drivers run free with
resource definition is highly likely to lead to an unmanageable mess
in the long run.  I'd strongly urge to gather consensus on what the
resources should be across the board.

> Design:
> ---------
> 8. Typically each RDMA cgroup will have 0 to 4 RDMA devices. Therefore
> each cgroup will have 0 to 4 verbs resource pool and optionally 0 to 4
> hw resource pool per such device.
> (Nothing stops to have more devices and pools, but design is around
> this use case).

Heh, 4 seems like an arbitrary number.  idk, it feels weird to bake in
a number like 4 into the design.

> 9. Resource pool object is created in following situations.
> (a) administrative operation is done to set the limit and no previous
> resource pool exist for the device of interest for the cgroup.
> (b) no resource limits were configured, but IB/RDMA subsystem tries to
> charge the resource. so that when applications are running without
> limits and later on when limits are enforced, during uncharging, it
> correctly uncharges them, otherwise usage count will drop to negative.
> This is done using default resource pool.
> Instead of implementing any sort of time markers, default pool
> simplifies the design.

So, the usual way to deal with this is that the root cgroup is exempt
from accounting and each resource tracks where they were charged to
and frees that cgroup on release.  IOW, asssociate on charge and
maintain the association till release.

For interface details, please refer to the following documentation.

 https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/tree/Documentation/cgroup.txt?h=for-4.5

Thanks.

-- 
tejun
