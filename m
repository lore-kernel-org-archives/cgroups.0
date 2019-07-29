From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 0/6] Add utilization clamping support (CGroups API)
Date: Mon, 29 Jul 2019 13:06:06 -0700
Message-ID: <20190729200606.GA136335@devbig004.ftw2.facebook.com>
References: <20190718181748.28446-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P3EUM+tzT2Mr9lYyH9h+ka7j8G70ef8Dl2l22x1qowY=;
        b=e68jNLw0799EKEVQytct+JZQNey8bkPM//gc4ZFMDQZt6EuWjdKKRGpVlCTMWq7Iqo
         A+dcRsjM4FizcWmU+Pe5CRlrHn1pVvJyOmfNMEJfMlsdrGvxgecpZ/Vz2EjV+oGs4zZv
         caDGsF7LjY/bt2zUP/pfgLlCSthMkMgm0P30KycyqAo/vHsx4JIUHzrLR6z1YlWrQHF2
         Z/O54RfdGRdkJdCERpIQTbLh8SD1teL8PkDFWC337LABr2NOIPBHPVBaqvBIZ+Fjr6S9
         FQfjphUq5UIZmZbQAPaqMS0yFAL1KgtnRWEoarVjXw+oyOU2oF5/pLul9G4CyNiLufzV
         Aw4Q==
Content-Disposition: inline
In-Reply-To: <20190718181748.28446-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>

Hello,

Looks good to me.  On cgroup side,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
