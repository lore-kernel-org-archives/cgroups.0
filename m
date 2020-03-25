From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Wed, 25 Mar 2020 15:19:22 -0400
Message-ID: <20200325191922.GM162390@mtj.duckdns.org>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rOPBVRyRj22r/QAr9s4b9CBOGy0xlM6KuJUxnB7ao+I=;
        b=WshBHS0wCQtRNGoEZsyzPMrxTJcVcepRsbvcpB1+hCJTpUBqa7ilY0cDflaaTzY0D+
         uuPEzzE2uM7eb/nZ0dwz2vQpq8xuKrREIdIVHuh1pixYEMyM+0/VFQqEKjYCQLmcvCoT
         VLXYgbgKtuUxFrVXKmAZsa4SQLponxT8Kush70OqvoWnIB4OCkzALZv/8lKYOXhKkdKb
         qlWfDaAFjW7GhpB/atmTETI+rYYxr1gufl0fZvq4474QfO6PTT7jCII1aDcQyQg/CUxX
         uA9anhzPVs0Zu7KLoWDg++XyTOIXQYVrFRiPJ7IG1SJtvv9/0XoeIZPm1i1TNET1liF3
         xCdQ==
Content-Disposition: inline
In-Reply-To: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 25, 2020 at 03:16:56PM -0400, Qian Cai wrote:
> The linux-next commit a49e4629b5ed (“cpuset: Make cpuset hotplug synchronous”)
> introduced real deadlocks with CPU hotplug as showed in the lockdep splat, since it is
> now making a relation from cpu_hotplug_lock —> cgroup_mutex.

Prateek, can you please take a look? Given that the merge window is just around
the corner, we might have to revert and retry later if it can't be resolved
quickly.

Thanks.

-- 
tejun
