From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to
 -mm tree
Date: Sun, 22 Jul 2012 10:34:29 -0700
Message-ID: <20120722173429.GF5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719113915.GC2864@tiehlicka.suse.cz>
 <87r4s8gcwe.fsf@skywalker.in.ibm.com>
 <20120719123820.GG2864@tiehlicka.suse.cz>
 <87ipdjc15j.fsf@skywalker.in.ibm.com>
 <20120720080639.GC12434@tiehlicka.suse.cz>
 <87d33qmeb9.fsf@skywalker.in.ibm.com>
 <20120720195643.GC21218@google.com>
 <500A107D.9060404@jp.fujitsu.com>
 <20120721024657.GA7962@dhcp-172-17-108-109.mtv.corp.google.com>
 <500A2A79.5030705@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gFJozZUgvpeo20qTaerjMLMoAG14tz/wvLyUrY3QCS8=;
        b=FkEujkfJ2iBkFidUlRGB+kK+RwplDotuvInwmZdEYo3DtSpvihUSOtJ6IUDJi2z6KY
         K4hQ8diNQNHyeB08SdU3Dqb5BlAdnhPbEbXy/XDwBRDIaCv/D9yswv8iXuR3h7Tr0yJv
         YJP76lBorkF5pHfi7VnmHiwsFLgtXvyjzDLnhyZpyYMIBm0qliZwO6HFnfQCt3lKYt6R
         7lXyHsKF2MHlHepk/7zcujfqRjrhI8iUOE7Nja6sQVuRXpzzX4KYW9GDWZw73XcZyC9F
         Dft7zRj+Lw75M14/nC1LNZxxr/gPpcbZ5U4TfoxMc1LIpXSxuoGJBM9A1CcDS6W8V/Jv
         X+RQ==
Content-Disposition: inline
In-Reply-To: <500A2A79.5030705-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Kamezawa-san.

On Sat, Jul 21, 2012 at 01:05:13PM +0900, Kamezawa Hiroyuki wrote:
> Maybe it's better to remove memcg's pre_destroy() at all and do the job
> in asynchronus thread called by ->destroy().

It doesn't really matter as long as ->pre_destroy() doesn't fail.  The
only meaningful difference between them is that pre_destroy() is
called before css refs reach zero (and can be used to drop css refs so
that destruction can happen).

> I'll cook a patch again.

Thanks!

-- 
tejun
