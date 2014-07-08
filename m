From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg
 depend on memcg on unified hierarchy
Date: Tue, 8 Jul 2014 18:03:43 -0400
Message-ID: <20140708220343.GK4979@htj.dyndns.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fLev5hrW4+qJhOMojqYxJP6kBu/n9bi3kJHOxIAyp1g=;
        b=mKm/e5H8OJp758me5RmL4kmZXGaBwYNC2AX04H04fgZrTa3vECCadJLQb6m1HghMvb
         Z8mDLfkKV8qzPhpV62YX/zEMZoSSzjMyhkHlB3TBna9G0lMLDxTQ3kfPOFtLWMOa8lLn
         GRk6PoW9nTfnI7onSuax4EKipgfrrEdNRe8v3Kcjqc5+qAzrKgBpTuYlvSBaCFrggXUA
         BLrHZ1yo4SAzU6Pd2+1DmdT3B+ukU6zJBsrgK35zGJ4i8I0fkhp7f+nfIydVf4sr0Adj
         xlSan+bD8VbkSslj4ufIj3HoMrhJnKKyGDfnoKlHifQRAdgP5ijOYKa3gz4ofVCMlN/p
         Pehw==
Content-Disposition: inline
In-Reply-To: <1403917392-32555-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Applied to cgroup/for-3.17.

Thanks.

-- 
tejun
