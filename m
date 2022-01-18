From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Tue, 18 Jan 2022 10:39:09 -1000
Message-ID: <Yeclbe3GNdCMLlHz@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTxSIYtF/qhDMdpcunv+R2Pnv7mrcydD4DvIe4qQgBA=;
        b=XzNVA7WFscHIr9quBbwN1Zl6DlOEBX9F8WsDR4fZuQmtO7dSeFEckqOuxbRK5Dbr36
         /eNURLliqpELZFheqowDPzNq72XN2bbp84c7+2gEmZWBXHzwINhnbQmHL+COLhW/mH7B
         sEyyYr0KSen0K0Oz8LuUJAMgc5YGn6FdzO6XUxUA0ZHD/46rOBRY6iZqcfjk3s4c3c+G
         tQ0FJvOpkvJ1cM8BKRmRfnNY0v9QN+Kor7sdjGPNwfcPoNNyO9VuyPm3JdHZi95ha43F
         kAYsOqWFk/ykFHxFzIQuyr5djbFrIif7ZEGmKHeNwzi3xNaqHdgLcnaN11LGGvahgN+J
         qjXA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jan 18, 2022 at 12:25:48PM -0800, Vipin Sharma wrote:
> Automated tools/scripts which delete VM cgroups after the main KVM
> process ends were seeing deletion errors because kernel worker threads
> were still running inside those cgroups. This is not a very frequent
> issue but we noticed it happens every now and then.

So, these are normally driven by the !populated events. That's how everyone
else is doing it. If you want to tie the kvm workers lifetimes to kvm
process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
exit wait for the workers to be cleaned up.

Thanks.

-- 
tejun
