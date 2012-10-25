From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 4/5] cgroup: net_cls: Pass in task to
 sock_update_classid()
Date: Thu, 25 Oct 2012 11:11:14 -0700
Message-ID: <20121025181114.GO11442@htj.dyndns.org>
References: <1351174619-5096-1-git-send-email-wagi@monom.org>
 <1351174619-5096-5-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r6/rOyba2nniJsfbO1AUH1hvVb/fgUW0vZ4zMYpJRMk=;
        b=TAiV8fyB2jsrd6qOTrXU5+5vqHfmTDa72udKUb/rIUrgmS5UseUdyzE/M2wCoQP79Q
         sM8UsfkDvSVqnVzx+v4nAMEO1dvs4DLYR7Vu8RIBBy0NDpYAXZRVhIAdtwJBXN4bkx4A
         +8ve18m+oG8GCIxzaczt+Vi8YCwPvcal+fDQA9+zBHRlO/jNX7SDsJCmi1cFZXUtRZvT
         Gf3qykPnIiva8cCl6BsQv4Me8h135Ay0wF67bhe+xys23BoDyt9rxnb6rPLHwt+Kp8LR
         j+FMfkttgsFXnIFFIqVit3TH9fbENI5uLMX3TOWoXbiwoo2lTPWaUWqzPGfRBI1aUmVV
         ypoQ==
Content-Disposition: inline
In-Reply-To: <1351174619-5096-5-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Thu, Oct 25, 2012 at 04:16:58PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> sock_update_classid() assumes that the update operation always are
> applied on the current task. sock_update_classid() needs to know on
> which tasks to work on in order to be able to migrate task between
> cgroups using the struct cgroup_subsys attach() callback.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Cc: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

1-4 look good to me.  I have no idea about 5. :)

Thanks.

-- 
tejun
