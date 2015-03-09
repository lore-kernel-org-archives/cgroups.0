From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroups: add an nproc subsystem
Date: Sun, 8 Mar 2015 22:34:27 -0400
Message-ID: <20150309023427.GB13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-3-git-send-email-cyphar@cyphar.com>
 <20150302152205.GC17694@htj.duckdns.org>
 <54FCFC39.6050900@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kwSDdmzdUKHqK2SlKVoEX2tsXeeLSb/f6YwBP8dgNLE=;
        b=Dhx0FkGSn0ErASYY0VQboWtVIDRMQuUb5jgljt1PHRkzfWL9+R8UNyJW+lrYlyF8yy
         llbTEk1DnaPmr+OCuv8Q9rD6iGJ34CRZ5U9XYR1ChcOzIG5RpBV9bxWRvwDgIJk7HVXF
         uizL+rVvPJ7J9sK7micm1lYEmIfIMVAqnhTES2n4yd2wlxU0PIWd5F/dYhz2+X3VWinS
         85zEH++8EKL86pL+Y0LCUHUHA2MY+XGJx8k/15CMETuw/B+tKhW8K7Xe7yCUtCkz6g6a
         oZGYowpU61oCQD9y7RsrRw/tNhkkKnfgHcJdjgWlBU7cKciG79KQodb/2/mSRE7e88xs
         r8zg==
Content-Disposition: inline
In-Reply-To: <54FCFC39.6050900-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li.

On Mon, Mar 09, 2015 at 09:49:45AM +0800, Zefan Li wrote:
> Seems we are going to accept this feature. Is it because kmemcg won't be able
> to fullfill this requirement? And that's because kmemcg can only and will only

Yeah, pretty much.

> be able to control global kernel memory usage? 

I'm not sure what you mean by global kernel memory usage.

> I thought there will be some control file like kmem.pids.max, which will
> translate the number of processes to the kernel memory needed, and fail memory
> allocation if we reach the limit, for example make task_struct slab return
> NULL.

Hmm... I don't think so.  memcg will only be concerned with actual
memory in bytes.

Thanks.

-- 
tejun
