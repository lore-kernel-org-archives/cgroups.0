From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add cgroupstats numbers to cgroup.stat file
Date: Mon, 21 Sep 2020 10:50:09 -0400
Message-ID: <20200921145009.GD4268@mtj.duckdns.org>
References: <20200915155349.15181-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I0TzWXUmgi2lOEHpdl5qmQ0obP+a5wT/52mUzrc/Cfw=;
        b=H4Yxk2SPjvLf2Brrla/hrvyq/OarS424J9FV8e1g25bELnn/LLXo44r2kzde5q0I7J
         mjKpYsrkCTWeDdh8qDWSf00x4bh8CXq+JPKScEkemo4j8xD+q4qfALCjyeqei3pKuLcm
         Bdr14uL8sNnC7bpzsT03ZCqVKKHeEsK0nTOUBKOKX+Xg+VQanXssvIv1+z4S+PxsIu8i
         mBxqLYlWeveKSKy74N3HJm/uDVIk+VyzU1dNJ0wKA1Kvz25vFyh8iu/SfcMVxF+GxRyn
         +0e8YMKCH/andqHfGTX8pEbimG8cSXJhvLiPuWljEK+LItU0WODLZNcFyUswDl+W+6XG
         i8fA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200915155349.15181-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Tue, Sep 15, 2020 at 11:53:49PM +0800, Chengming Zhou wrote:
> In the cgroup v1, we can use netlink interface to get cgroupstats for
> a cgroup. But it has been excluded from cgroup v2 interface intentionally
> due to the duplication and inconsistencies with other statistics.
> To make container monitor tool like "cadvisor" continue to work, we add
> these cgroupstats numbers to the cgroup.stat file, and change the
> admin-guide doc accordingly.

So, we can't add O(nr_threads) operations to cgroup.stat reads. There are
two ways forward that I can see.

* Investigate how these counters are being used. If it's used for congestion
  detection, pressure metrics are likely better indicators to use anyway. If
  the usage frequency is low enough, maybe querying from userspace should
  work?

* If the need for these per-cgroup task state counters is really
  justifiable, the counters should be maintained from scheduling event
  directly and summed up using rstat like other statistics.

Thanks.

-- 
tejun
