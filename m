From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/cgroup/reclaim: Fix dirty pages throttling on cgroup
 v1
Date: Fri, 18 Nov 2022 18:43:46 -0500
Message-ID: <Y3gYsv6oAcJ2u0Py@cmpxchg.org>
References: <20221118070603.84081-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/iTpmR4sRdLv0Rk3A8XEP/l6NiYPL92CF45ZyTgAiU=;
        b=gsWF7RmdFZNApUCqHEyf0BafcUrFVHnUgIS7HhgpUNR5xF9VvlzTIR5biXLQLJAtux
         ef1rp8dfIEcWWTpYDLJSxGwb35YMj4OcmP+tdOx2Fr4vTWGgN2XS2NtPbcroIz8XKl4v
         FNhXlg07RHUWM4bfGIaZ7i6wMsSfF+pCELt+P+9QZRmTkbnrqcjpAFUZjLFsEapoxUsy
         OMy1jNRSZJsxU+SqK2GdMJbnM8ptspzNHM41EB5x1wPnpWgIDPBEHkEOa4qM4JIIXMO7
         15q1sHnkCMenDiRbzLQIew81n2tPXEb926GxiXB24xnKLs9+3HFdVuWpl6r8Oc7mlhkt
         bGOQ==
Content-Disposition: inline
In-Reply-To: <20221118070603.84081-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Fri, Nov 18, 2022 at 12:36:03PM +0530, Aneesh Kumar K.V wrote:
> balance_dirty_pages doesn't do the required dirty throttling on cgroupv1. See
> commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback on
> traditional hierarchies"). Instead, the kernel depends on writeback throttling
> in shrink_folio_list to achieve the same goal. With large memory systems, the
> flusher may not be able to writeback quickly enough such that we will start
> finding pages in the shrink_folio_list already in writeback. Hence for cgroupv1
> let's do a reclaim throttle after waking up the flusher.
> 
> The below test which used to fail on a 256GB system completes till the
> the file system is full with this change.
> 
> root@lp2:/sys/fs/cgroup/memory# mkdir test
> root@lp2:/sys/fs/cgroup/memory# cd test/
> root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes
> root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks
> root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M
> Killed
> 
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks Aneesh
