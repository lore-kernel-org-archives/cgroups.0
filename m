From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Thu, 3 Aug 2023 16:55:55 +0200
Message-ID: <ZMu/+ysmksCZqcem@dhcp22.suse.cz>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com>
 <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
 <CAJD7tkbb8AWR-duWb+at-S9MMz48b0JqnM+b5ok83TzvXvPb+A@mail.gmail.com>
 <CAJD7tkbZi16w4mYngVK8qA84FMijmHvwzMjHfrJiCsV=WjixOA@mail.gmail.com>
 <ZMoIYLwITUZzXp4C@dhcp22.suse.cz>
 <CAJD7tkY4hTTCfqSGa_XexbH=WSTJ4WXWeMXSU+6KW8qfr7agfQ@mail.gmail.com>
 <CAJD7tkb17x=qwoO37uxyYXLEUVp15BQKR+Xfh7Sg9Hx-wTQ_=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691074556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/VNlnAgBc91S2tYQvLwrXhvlLqKeVtz0vo49rvSQNPE=;
        b=kVP0di1gzsJsEBbQQkq4/uiFNVNskhJjfzgyi/9R6Qhac7n1+AnbpJ3GFGHXK1e+0/sDW6
        sq63HRQ8VLd7ptKuupjYjswPoJqTloEdleyab3q5EYZ4DzgBIi9l/Py/OhKsDxNCtMEd3n
        8pBrxdzb8ugos/N86bbFPaoIGR7Bv4s=
Content-Disposition: inline
In-Reply-To: <CAJD7tkb17x=qwoO37uxyYXLEUVp15BQKR+Xfh7Sg9Hx-wTQ_=w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 02-08-23 15:02:55, Yosry Ahmed wrote:
[...]
> Let me know if the testing is satisfactory for you. I can send an
> updated commit log accordingly with a summary of this conversation.

Yes this should be sufficient as it exercises all the CPUs so the
overhead in flushing should be visible if this was a real deal. I would
have gone with kernel build test as that has a broader code coverage but
this artificial test should give some red flags as well. So good enough.
Amending the changelog with this would be helpful as well so that future
us and others will know what kind of testing has been done.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> 
> > > --
> > > Michal Hocko
> > > SUSE Labs

> #!/bin/bash
> 
> NR_CPUS=$(getconf _NPROCESSORS_ONLN)
> NR_CGROUPS=$(( NR_CPUS * 2 ))
> TEST_MB=50
> TOTAL_MB=$((TEST_MB * NR_CGROUPS))
> TMPFS=$(mktemp -d)
> ROOT="/sys/fs/cgroup/"
> ZRAM_DEV="/mnt/devtmpfs/zram0"
> 
> cleanup() {
>   umount $TMPFS
>   rm -rf $TMPFS
>   for i in $(seq $NR_CGROUPS); do
>     cgroup="$ROOT/cg$i"
>     rmdir $cgroup
>   done
>   swapoff $ZRAM_DEV
>   echo 1 > "/sys/block/zram0/reset"
> }
> trap cleanup INT QUIT EXIT
> 
> # Setup zram
> echo $((TOTAL_MB << 20)) > "/sys/block/zram0/disksize"
> mkswap $ZRAM_DEV
> swapon $ZRAM_DEV
> echo "Setup zram done"
> 
> # Create cgroups, set limits
> echo "+memory" > "$ROOT/cgroup.subtree_control"
> for i in $(seq $NR_CGROUPS); do
>   cgroup="$ROOT/cg$i"
>   mkdir $cgroup
>   echo $(( (TEST_MB << 20) / 4)) > "$cgroup/memory.max"
> done
> echo "Setup cgroups done"
> 
> # Start workers to allocate tmpfs memory
> mount -t tmpfs none $TMPFS
> for i in $(seq $NR_CGROUPS); do
>   cgroup="$ROOT/cg$i"
>   f="$TMPFS/tmp$i"
>   (echo 0 > "$cgroup/cgroup.procs" &&
>     dd if=/dev/zero of=$f bs=1M count=$TEST_MB status=none &&
>     cat $f > /dev/null)&
> done
> 
> # Wait for workers
> wait


-- 
Michal Hocko
SUSE Labs
