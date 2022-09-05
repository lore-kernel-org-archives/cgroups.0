From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Mon, 5 Sep 2022 15:14:35 +0200
Message-ID: <20220905131435.GA1765@blackbody.suse.cz>
References: <YxUUISLVLEIRBwEY@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662383676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=odeJqpDcCxpX8r1tp05w8dWsivXfrVnH9KQIlvGGAiY=;
        b=mH9nstggkl70jXef3R7A+xB5wXtVaBly5uw2TFaShC6zQMLS/K1tV2TfXViaXp7qVa2ajW
        G+ATz4m570suY1xDlEeBUIQOgXxmRujMPHfQ3ez7mec6d/rcmWBrWyLCyvl1JkhDbt9JkX
        hmEmwi4tjQ1y8tf+vDDt5bnRd7NeUqY=
Content-Disposition: inline
In-Reply-To: <YxUUISLVLEIRBwEY-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello.

On Sun, Sep 04, 2022 at 11:09:53AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Let's track whether a cftype is currently added or not using a new flag
> __CFTYPE_ADDED

IIUC, the flag is equal to (cft->ss || cft->kf_ops), particularly the
information is carried in cfs->kf_ops too.

Is the effect of cgroup_init_cftypes proper setup of cft->kf_ops?
I.e. isn't it simpler to just check that field (without the new flag)?

(No objection to current form, just asking whether I understand the
impact.)

Thanks,
Michal
