From: =?UTF-8?B?0JXQvdGM0YjQuNC9INCQ0L3QtNGA0LXQuQ==?= 
        <and.enshin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: reclaim memory from cgrouped app(/kernel)
Date: Tue, 5 Apr 2022 18:37:10 +0900
Message-ID: <CAHoi7SvtE971BuMWwnt=8V-DutO5=sgUGow637MiPq_+3NYbQg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=8YjdKne984sfE1TFRfUKmP3/44deiAaiEdvrqOqJMtM=;
        b=EqSwsfAKfrawy7t8TIrkzB/pZuBKFa36fgsssyo48iNUnMIxKKRCf1pXgUYzWJ7BgI
         85YRcfppFcrZOBaNypf0/3E5uGd4IvH7X5YoyMfDRrdevnX2q1BfQDMkv1yqKbtkPIZL
         nCw+nhuyrA65FLKhcnbp+0dIsdQ6b+1sviHN5uoUrUnzKg1eplyo1+haaW+BpwKQZl3k
         CrhlIYflzKyANa1FtIiXtV0mgZ5/ZIEKcYQ0ThZ+fJUbRY5vSNdD6DqWY++eVL7AeDHw
         04k4Wij0SCOFfWQ+uv7pcUNaGRfHsa4RCsz6y0MqNRBSuZyDz9mcycQYlh7KbH+sfWCv
         pOEg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

does kernel reclaim memory inside cgroup - from apps running inside
cgroup and from part of kernel taking memory somehow related to this
cgroup - if there is no overall memory pressure in system but memory
usage in this particular cgroup is close to limit?

If yes, will kernel reclaim pages marked as MADV_FREE?

-- 
Best Regards,
Andrei Enshin
