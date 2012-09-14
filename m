From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 13:39:25 -0700
Message-ID: <20120914203925.GR17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
 <20120914192840.GG6221@redhat.com>
 <20120914194439.GP17747@google.com>
 <20120914194950.GQ17747@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5CeHuIL5WKJASV/8EWE8Zw0K/vWKd9eRWEP7xMRlMaM=;
        b=tTUef727TKIRX31jq8t3YgoyFSCuM6MDq3aJde0dQFVwlJfDOzJ3NmtMIwDhRrR9qp
         RIsSqmPD3dQUzxveAorgjBLmGAV/1lSy2VjqRF1gXfikMBQCB+Ogixi4OS/xdFLyW5vP
         m0SiMqz5SZP+NHlfnEvaX0O1dvvPpTU1KCu5RsBb7Vn3I7UDVCdwhWXahRb+zwvEWoQ4
         FsRLsq3n01CRuxomia8QUkbRXEDVS4spwqiQyGodadf4iS3VCL8+ewPNclI74yqQeNtc
         be7Mgol6wjTszhg8fG7n2qCPDd2tLYUUFATKnkpg57kUzmFinkMd5lJ2icLBJxuBg8E5
         T+FA==
Content-Disposition: inline
In-Reply-To: <20120914194950.GQ17747-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Hello, again.

On Fri, Sep 14, 2012 at 12:49:50PM -0700, Tejun Heo wrote:
> That said, if someone can think of a better solution, I'm all ears.
> One thing that *has* to be maintained is that it should be able to tag
> a resource in such way that its associated controllers are
> identifiable regardless of which task is looking at it.

So, I thought about it more.  How about we do "consider / ignore this
node" instead of "(don't) nest beyond this level".  For example, let's
assume a tree like the following.

        R
     /  |  \
    A   B   C
   / \
  AA AB

If we want to differentiate between AA and AB, we'll have to consider
the whole tree with the previous sheme - A needs to nest, so R needs
to nest and we end up with the whole tree.  Instead, if we have honor
/ ignore this node.  We can set the honor bit on A, AA and AB and see
the tree as

        R
     /
    A
   / \
  AA AB

We still see the intermediate A node but can ignore the other
branches.  Implementation and concept-wise, it's fairly simple too.
For any given node and controller, you travel upwards until you meet a
node which has the controller enabled and that's the cgroup the
controller considers.

Thanks.

-- 
tejun
