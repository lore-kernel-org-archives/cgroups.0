From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v4 2/3] add missing bpf-cgroup.h includes
Date: Wed, 15 Dec 2021 08:28:14 -1000
Message-ID: <YbozvuaPMu58RqU2@slm.duckdns.org>
References: <20211215181231.1053479-1-kuba@kernel.org>
 <20211215181231.1053479-3-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ljp+r2/uwwJFUdX/+JTcBmL6u7/IlJQzL4z/nVQyjLQ=;
        b=DMRQ5tYS8xfdjkB/0Bu6POtAC9xPB3oOWHQ3zp+tyyxHvPYs/QTZTi3zPJX4A6Y5F3
         nGEdDCNDIi88nqZqirGia2JnkFbUNdlY3RGfvIBjp9s6OD2sYnPeP4Q7r5Wed7PJZ0Y3
         +AMiAEx2pHtnQ/86Qy4BtgxnoumB1K+ZkR+Ym9t5p0kW4ZzIe2uRaD9LdVAlS8XcMKOW
         Ll37jAXwZgET3DQMqrmd6+YoemVFMwBYKaoP467YQ5LUTNKJxMRyFqPsqRwjbXsNw1aN
         txz/TDUtfF4BADU1sWh7PR9Gc3AvMFIeHeTVSpfp3mDwV7xLtbDNTUMwKHEkl9hBRrb+
         TYag==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211215181231.1053479-3-kuba@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba@kernel.org>
Cc: daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org, bpf@vger.kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmorris@namei.org, serge@hallyn.com, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org

On Wed, Dec 15, 2021 at 10:12:30AM -0800, Jakub Kicinski wrote:
> We're about to break the cgroup-defs.h -> bpf-cgroup.h dependency,
> make sure those who actually need more than the definition of
> struct cgroup_bpf include bpf-cgroup.h explicitly.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
