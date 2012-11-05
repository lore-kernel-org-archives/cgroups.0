From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RESEND v2] cgroup: simplify cgroup removal path
Date: Mon, 5 Nov 2012 09:30:24 -0800
Message-ID: <20121105173024.GA19354@mtj.dyndns.org>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6fyzmdphXBmbIJiqwj7k08rb/m/l2RQ3FTDW3sTk0Oo=;
        b=LBxDOLg0q6POQ8tdFq/pJaOTvD9I5hsFV1vyTOzIExzbM1HbLlyD6CAlJedvZ7CBZU
         5gNzDD70ufok6DX33LqbDxH1+S+UUtoGzO2FwM3dd8VmHoZbmAgBTmlzMgAdcwvpCzI6
         8WdgwM631VftaBU1oEG5ZDHNSlWLDb6A/glgBHRNOUMjnZlWjAjHWF1iHg7tcf5Dj7f3
         qt9nPg3C0qFAEXntLfNS1+re+Ynu+Z6AjM54Qdu1Ru7xa1d7f7WONdhcJ//u3qNdKYb+
         K3w2uo090kAoxh5dQ2oBCTG4K8b444r10YUNMYHFgWrtYDbpZMpz2ScLePWDjCWlcETZ
         QBRQ==
Content-Disposition: inline
In-Reply-To: <1351712650-23709-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/cgroup-rmdir-updates and then pulled into
cgroup/for-3.8 w/ Li's acks added.

Thanks.

-- 
tejun
