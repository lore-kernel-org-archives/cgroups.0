From: Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH 0/3] Rework locking when rendering mountinfo cgroup
 paths
Date: Tue, 23 May 2023 14:09:12 +0200
Message-ID: <20230523-salamander-gemeldet-b549ea345cf8@brauner>
References: <20230502133847.14570-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684843758;
        bh=3HvMiLwSxwQEG8Ntmcawz72NdT2pUbel5Q8Sk7Zjzik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJ2qIB74oDOP+PUdnYONaOPP2l2LQGFy/WVyW1zNXHabrGks7kUzGD+Oh8zH3hO8w
         FD7fwqyB58gRA9260iNFdDIkIX60E6tFGmX+7enMxHmTSGvRrutzOkNcD2Y14/cSfJ
         1FluobWOkijaPdBgyxPv1hUEpLPCkTDdjxLsKjfd9XevhkcRd1xN+fxjPqLTJnqPg3
         bXmdRyvpwgOTeoPgCoR+0hJF5gRv5Lb0OsuG1lxUN7B4Zyn6ymo3qlRDNUjugjWito
         /x3quZKgWRZQBbpi4ClKR3b8Ey5XZwYT+usTx63Bqcbmdh1kj5xdD2OL/hM9fpuww3
         VtqMoRCM6ysWQ==
Content-Disposition: inline
In-Reply-To: <20230502133847.14570-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

On Tue, May 02, 2023 at 03:38:44PM +0200, Michal Koutn=C3=BD wrote:
> Idea for these modification came up when css_set_lock seemed unneeded in
> cgroup_show_path.
> It's a delicate change, so the deciding factor was when cgroup_show_path =
popped
> up also in some profiles of frequent mountinfo readers.
> The idea is to trade the exclusive css_set_lock for the shared
> namespace_sem when rendering cgroup paths. Details are described more in

I have no issue with the cgroup specific part of relying on
namespace_sem but kernel/cgroup/ has no business of being aware of
namespace semaphore in any way. Leave a comment to clarify what you're
doing but we're not going to sprinkle namespace_sem references - even if
only for the sake of lockdep - into other subsystems.
