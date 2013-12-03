From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 07/12] cgroup: unify cgroup_write_X64() and
 cgroup_write_string()
Date: Tue, 3 Dec 2013 22:04:11 +0100
Message-ID: <20131203210411.GB3764@dhcp22.suse.cz>
References: <1385595759-17656-1-git-send-email-tj@kernel.org>
 <1385595759-17656-8-git-send-email-tj@kernel.org>
 <20131128111818.GG2761@dhcp22.suse.cz>
 <20131129200525.GC21755@mtj.dyndns.org>
 <20131202095401.GA18838@dhcp22.suse.cz>
 <20131202133059.GA3626@htj.dyndns.org>
 <20131202141242.GD18838@dhcp22.suse.cz>
 <20131203204155.GL8277@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VqtjhpDRoYXk7FS8Z2VBRC4ij3mX4ePEtwQrfDIiYnA=;
        b=D4cRjIrVKb/vPO7jTxCFINijOqINekZ9sKoikbhjd1Cyvt/eW4jH2iiGtdpnQd10at
         kg00aShzJHsAHT/CUayQWHAldgXU9l8Bx2/pQhbnxhCRlxTrOzE4Z/HGPiVRKidKPh2O
         L9/fXqomvFjmXdtDE7uRdNTmkwueUIO043yqFsP8aWIqTJlOqlyei9OXX/Z6Lf9uKqJo
         QNlzCLR9CLc9iqep7gI4nmC2qVGe/ni2Sen+kSu3sYR1dv/xOTtPTOqxoXX6J3Ot4LNO
         gOCy+N7L93J0k72Jf83dvChGMYm+B59aQw4fd3Txd4Iu+rKk91eWY0FTh46ShKpTRhwO
         X+Rw==
Content-Disposition: inline
In-Reply-To: <20131203204155.GL8277-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue 03-12-13 15:41:55, Tejun Heo wrote:
[...]
> In case this *really* is necessary, let's please do it in a separate
> patch with rationale and detailed explanation of actual usage.

I am fine with this.
-- 
Michal Hocko
SUSE Labs
