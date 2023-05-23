From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 2/3] cgroup: Rely on namespace_sem in
 current_cgns_cgroup_from_root explicitly
Date: Tue, 23 May 2023 09:12:31 -1000
Message-ID: <ZG0QH7gvKNFj0n34@slm.duckdns.org>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-3-mkoutny@suse.com>
 <20230523-radar-gleich-781fd4006057@brauner>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684869154; x=1687461154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDHOuli6LQC21PVL1jIVJHkKd4nR+BXbovWUBQJSo5E=;
        b=nnt2ZPVfDdLgMsE9DXatFeQI53mTIFlO7r2+Zrd8elz107npuksySY3Ik1QMx5QeNX
         HuOBQsQNrA/4wYyDJaFh9NPUg8lo6sK8UdVOIgh+yku9tcUmeqEKa1bmSLkHCTZpNAtZ
         phaeSMPxMN6d+QDQDOK5pKidVFhjxa9v8JZl8GD2g18uY+eHydQG8lOel3kyJgBZ2CuN
         xouiWeZ9l9EroDXJDxzAli1p9aGcoARKs2ChHGPIQKpLGakbEcGpuWxumVEiUfOrzOai
         PFDoRS2Y0B6VOAwv/BIKMqp47OYcP++4oJc4kvO3xaJx4T5OdMssVkhoz1Hwoer8UTyA
         uzzA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230523-radar-gleich-781fd4006057@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

Hello,

On Tue, May 23, 2023 at 12:42:46PM +0200, Christian Brauner wrote:
...
> Nope, we're not putting namespace_sem in a header. The code it protects
> is massively sensitive and it interacts with mount_lock and other locks.
> This stays private to fs/namespace.c as far as I'm concerned.

Michal, would it make sense to add a separate locking in cgroup.c? It'll add
a bit more overhead but not massively so and we should be able to get
similar gain without entangling with namespace locking.

Thanks.

-- 
tejun
