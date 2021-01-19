From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] cgroup: update PSI file description in docs
Date: Tue, 19 Jan 2021 11:56:18 -0500
Message-ID: <YAcPMlxXVSuKgbvn@cmpxchg.org>
References: <20210116173634.1615875-1-odin@uged.al>
 <20210116173634.1615875-3-odin@uged.al>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sZTa1e704AQTw+PA3+InMjpu4zvF9XQf/ysLpHwUHcU=;
        b=R+13BIlUYlJXhmZNL640hNlcxlCK/mz4E7yBIiR4htjWXaoPhuig0r+qwQBLWUGBpn
         cCIgnGt9JsYOkwwOzJHQ6LVCfPP46U5UjUFiKz8OoSEBFzVdPvnszAO/xrZ2HxLmaZ4u
         m7rgmUL6+l9w3MXBvK8/FyuWlbRIp1HxP9nTh93Fryowg9RhjdDnQ+ATKo2iqlhbcuAz
         em8PW3JSYOgeeloQZXqsLJGnLGn8JuGhSFzyDGqZIvlhnVj1HFNTVwSVB6t9D3bdsrmp
         h6Spn8Duch3qGBAYlOLOLrYinfYFom1kHkna9i6qhL16UV3OuEhhZ3R/GEE/ufTB3Idv
         nbtA==
Content-Disposition: inline
In-Reply-To: <20210116173634.1615875-3-odin@uged.al>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@uged.al>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dschatzberg@fb.com, surenb@google.com

On Sat, Jan 16, 2021 at 06:36:34PM +0100, Odin Ugedal wrote:
> Update PSI file description in cgroup-v2 docs to reflect the current
> implementation.
> 
> Signed-off-by: Odin Ugedal <odin@uged.al>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 63521cd36ce5..f638c9d3d9f2 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1029,7 +1029,7 @@ All time durations are in microseconds.
>  	one number is written, $MAX is updated.
>  
>    cpu.pressure
> -	A read-only nested-key file which exists on non-root cgroups.
> +	A read-only nested-keyed file.

Could you please also change the 'read-only' to 'read-write'?

With that, please feel free to add:
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
