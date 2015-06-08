From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13 2/5] cgroup: replace explicit ss_mask checking with
 for_each_subsys_which
Date: Mon, 8 Jun 2015 18:21:07 +0900
Message-ID: <20150608092107.GH21465@mtj.duckdns.org>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
 <1433548938-32560-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GoLn2SRsx5wokMI9baDSUUB3BYGHkzjauAhVpy677mA=;
        b=lXThfE3C9Ch+tNsMJpwCTE4ypgvNNV+hMciO3i8/PJtOZ/qveu5yuqsyZkSThb+AGl
         a9Hyr/ZJ9KvyDIAiSnFNvyIER1NnlVwbOmYCwdXT4x2NbmjenzrsM2/MXs2tncPJA50f
         ZVzoBV0Sd5HW3AuDxASFcy4i9pAHsF5oM8piHaiIFiumAHkBKl0VLhD+JZwZNc09Dlbh
         0IFHATpTRCuM53zf+OSskOzgzrSlZSMxuRNShjZe3BuGu5V5eKDxi6iinLhB0DAsVTni
         pQUqZhqPY/svXDvQFH6zGueOuxgOZpmHBP59MtIZ3sM3LFsr/8tBLwM18TM5gTcNDEyo
         zxmw==
Content-Disposition: inline
In-Reply-To: <1433548938-32560-2-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 06, 2015 at 10:02:15AM +1000, Aleksa Sarai wrote:
> Replace the explicit checking against ss_masks inside a for_each_subsys
> block with for_each_subsys_which(..., ss_mask), to take advantage of the
> more readable (and more efficient) macro.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-4.2.

Thanks.

-- 
tejun
