From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 12:18:11 -0400
Message-ID: <20150415161811.GD30337@htj.duckdns.org>
References: <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
 <20150415150302.GA25089@mail.hallyn.com>
 <20150415151926.GS23123@twins.programming.kicks-ass.net>
 <20150415153035.GA25390@mail.hallyn.com>
 <20150415154802.GB30337@htj.duckdns.org>
 <20150415161534.GA25776@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JSMtfx7mbmtM9nDJ13uJZCwm3vUpEgomx7zYtI272ew=;
        b=cj7eGWyJ42GUQShRkVeYedTHF9HYN5osIHvOIHfAkIB0asEZ5QcP0pkQ8m0n4UJQB5
         lPFU0OmA11EMI3kxSubczYKzx2lB8WkWoM1UYjLkljyq3HMvmlSpagEgnXyttMX7ag8A
         wwaT6lgrbtzmYD7M56z0PgpiS21cUycK/T9gQgojMdlG6Dp+/NZaAGsVyPptjsn/QNjS
         H64qg2ZE7cMCliMOr/g1f+Z/cqWpT20R6OJpzQbGspfi2U5JwElduR5lBkOk5SI/VuK8
         j6YGWVF9/aZ1kibdAGLUaWXI6bRaavan4ZK8q7MOxBXwgYvfl8MGDnOwNyPqaI+ivTim
         X4pw==
Content-Disposition: inline
In-Reply-To: <20150415161534.GA25776-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Apr 15, 2015 at 11:15:35AM -0500, Serge E. Hallyn wrote:
> The reason would be because it breaks "legacy" software.  So that
> would only matter if Preeti needs to run such software.

Sure, I get that argument but this is changing how the contorller
behaves in a major way.  There are specifics which may make this
particular case more justifiable but overall the combination of
arguments is pretty weird.

Thanks.

-- 
tejun
