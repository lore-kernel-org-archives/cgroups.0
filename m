From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 09:07:33 -1000
Message-ID: <Y35vdbcVYx99zePI@slm.duckdns.org>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <Y35Swdpq+rJe+Tu3@slm.duckdns.org>
 <5fccf438-fdbe-1bc8-6460-b3911cc51566@redhat.com>
 <Y35sbREgYE6aIdIp@slm.duckdns.org>
 <a89de82d-41e7-a40f-a5a3-83ad62bf383f@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJ1XxPBP6l91zCvLonYfrAhVHQ+WkP/p/oLP73T5QzE=;
        b=AYyIeS27Ml0qFv4GlN+J2HpoE/+ez5mP3DcQSSSmQVPSkehPvX45k2Pm/f0poKKmAn
         JkEzBXH/AItqzO4I/wVi8+WjPCIkFphvfmjws+xNBp7QlMPlGPBYAWh08Vn15kzcumFC
         VvGXi0KmtdQKUGtxC1Qtb2eE87cCKKOIRz7ZEWWLdWKCae7goewehyPTWXahQMp87mQX
         O0EEpF3Rok7izhkHeTtFsyuZEPnOD3QNCZuuqLVSqhkc8HQ51kp30LJfyTtsu5E8vUCc
         atJfeK2l/4ayUmLyTxU1Xrw3a6CTqA+S58Btpu0n+Xlx3NwKuq6bTFCBvLGNBBUqki+a
         5+kw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a89de82d-41e7-a40f-a5a3-83ad62bf383f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:05:59PM -0500, Waiman Long wrote:
> Right, the group leader is just a marker to make it easier to avoid
> duplicating the work for the same mm. If the group leader happens to be in
> another cpuset, it will suffer some performance consequence.

Yeah, I guess that's gonna be good enough for most cases.

Thanks.

-- 
tejun
