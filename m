From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3 2/3] cgroup: drop
 cgroup__DEVEL__legacy_files_on_dfl
Date: Thu, 15 Oct 2015 16:59:40 -0400
Message-ID: <20151015205940.GB3788@htj.duckdns.org>
References: <20150805172012.GO17598@mtj.duckdns.org>
 <20150805172043.GP17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JtQpPV51V6gRMwLRhva3UWxqtSqosqW/HzgqWAsSVn0=;
        b=LMGg/ywlKaa9+1q6WSLH+jtWzBNQWIAijpfncdQB5/muxBz6iCyAQe++hzjiqeuIgR
         56nttess8A5Wvkst1QDSA7qwEmo/2dXBrFP+M6V/YpXl2fHtDmNZETbfO/RALkucQB+1
         UePSngpMjsqMWfPjyTYrmpKNibN6vOZuSAFuWyoxZrqfz5MTc6EDgEyGMwffezmNJY5o
         M0iRNq1vmG5Jyig1utvkslxGd6Xpsudo7VBZZcNdvCj9zxys00G0XOH3b8y36FxDlgHo
         nBZqLsoWoT8ewClRxX27sILil1aoajvD4nsbIqk6Cjw/wA3aNlFdrNo3VgbhndVGlmKM
         x+hA==
Content-Disposition: inline
In-Reply-To: <20150805172043.GP17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Aug 05, 2015 at 01:20:43PM -0400, Tejun Heo wrote:
> Now that interfaces for the major three controllers - cpu, memory, io
> - are shaping up, there's no reason to have an option to force legacy
> files to show up on the unified hierarchy for testing.  Drop it.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Applying 1-2 to cgroup/for-4.4.  Will apply the third one once the cpu
controller discussion reaches some resolution.

Thanks.

-- 
tejun
