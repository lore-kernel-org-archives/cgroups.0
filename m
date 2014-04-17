From: Raghavendra KT <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 12/12] cgroup: implement dynamic subtree controller
 enable/disable on the default hierarchy
Date: Thu, 17 Apr 2014 23:33:50 +0530
Message-ID: <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
	<1397511430-2673-13-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=yMey5tFm+0lF8OLEkev5ZhbxA1mo9UixW4Y4MLSRDbA=;
        b=HL9B4zrGEeKl2EGO+iiS0jHfeoC8rpD7ZHQm6aEB7WSaEZSnpaEULtBmV5Ys0Glei1
         M4hAOD0fz8KNdqfpmILvnfosi2Z/G/PPsWgjQp3a29t8LVjZ8+E0HkPdUy3sTr12L+qq
         owXyGtcTxUklhxE/Cg6TdmqitOPq5nZ2pSNDDgwrYksUFJKWlDk4dEkr4v+wKmdTELrG
         asu1RxTROmvVIl338XBtmPUO1wf4qa0WBCHRzN+J4u2ayA1g/uA1lmwYfLADCFpeywQn
         kFTbPdOC/Vxbdx04JOWy6zKsC5PJP4OXT8xgy2gXg4aw8NSbPZdeSnfT+0lb7DfnVR8X
         RABg==
In-Reply-To: <1397511430-2673-13-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Apr 15, 2014 at 3:07 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> * White-space separated list of controller names prefixed with either
>   '+' or '-' can be written to "cgroup.subtree_control".  The ones
>   prefixed with '+' are enabled on the controller and '-' disabled.
>

[...]

> +
> +/* change the enabled child controllers for a cgroup in the default hierarchy */
> +static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
> +                                       struct cftype *cft, char *buffer)
> +{
> +       unsigned long enable_req = 0, disable_req = 0, enable, disable;
> +       struct cgroup *cgrp = dummy_css->cgroup, *child;
> +       struct cgroup_subsys *ss;
> +       char *tok, *p;
> +       int ssid, ret;
> +
> +       /*
> +        * Parse input - white space separated list of subsystem names
> +        * prefixed with either + or -.
> +        */
> +       p = buffer;
> +       while ((tok = strsep(&p, " \t\n"))) {
> +               for_each_subsys(ss, ssid) {
> +                       if (ss->disabled || strcmp(tok + 1, ss->name))
> +                               continue;
> +
> +                       if (*tok == '+') {
> +                               enable_req |= 1 << ssid;
> +                               disable_req &= ~(1 << ssid);
> +                       } else if (*tok == '-') {
> +                               disable_req |= 1 << ssid;
> +                               enable_req &= ~(1 << ssid);
> +                       } else {
> +                               return -EINVAL;
> +                       }
> +                       break;
> +               }
> +               if (ssid == CGROUP_SUBSYS_COUNT)
> +                       return -EINVAL;
> +       }

I undertsand that with the above parsing we could do
echo "-blkio +blkio" > cgroup.subtree_control and honor last enable/disable.
It confused me while testing. do you think we should return -EINVAL in
such case?
